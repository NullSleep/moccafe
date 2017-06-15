//
//  NewsTableViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 6/3/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import SwiftyJSON

class NewsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    let apiHandler = APICall()
    
    var articles = [Article]()
    var atPage: Int?
    
    var delegate: performNavigationDelegate?
    var url = "https://app.moccafeusa.com/api/v1/blogs/news_articles"
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    
    init(style: UITableViewStyle, itemInfo: IndicatorInfo) {
        self.itemInfo = itemInfo
        super.init(style: style)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 370
        tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.lightGray
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        self.refreshControl = {
            let refreshControl = UIRefreshControl()
            return refreshControl
        }()
        self.refreshControl!.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(self.refreshControl!)

        retrieveArticle(page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellData: NSDictionary = [
            "date": articles[indexPath.row].created ?? "",
            "title": articles[indexPath.row].title ?? "", //"Coffee Drinkers May Have One Less Type Of Cancer To Worry About",
            "subtitle": articles[indexPath.row].content ?? ""
            //"Coffee offers so many benefits already. Now we can add ‘cancer fighter’ to that list."
        ]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell else { return PostCell() }
        let data = cellData
        cell.configureWithData(data)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if delegate != nil {
            delegate?.loadDetail!()
        }
        
    }
    
    func retrieveArticle(page: Int) {
        
        
        var json: JSON = [:]
        json["blog"] = ["pagina": page]
        
        apiHandler.retrieveArticles(url: self.url, json: json) {
            json, error in
            if json != nil {
                let articles = json!["blog"]["articles"].arrayValue
                let pageRetrieved = json!["blog"]["page"].int
                
                if pageRetrieved == page {
                    self.atPage = page

                    for item in articles {
                        let article = Article()
                        if let created = item["created_at"].string {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                            if let date = formatter.date(from: created) {
                                formatter.dateStyle = .medium
                                let dato = formatter.string(from: date)
                                article.created = dato
                            }
                        }
                        
                        article.content = item["info"].string
                        article.picUrl = item["picture_url"].string
                        article.liked = item["liked"].bool
                        article.title = item["title"].string
                        article.videoUrl = item["video_url"].string
                        
                        self.articles.append(article)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.articles.count-1 {
            if atPage != nil {
                retrieveArticle(page: atPage!+1)
            }
        }
    }
    

    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        articles.removeAll()
        retrieveArticle(page: 1)
        self.refreshControl!.endRefreshing()
    }

}
