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
import SDWebImage


class NewsTableViewController: UITableViewController, IndicatorInfoProvider {
    
    let apiHandler = APICall()
    
    var articles = [Article]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var retrievedArticles = [Article]() {
        didSet {
            if !retrievedArticles.isEmpty {
                articles = retrievedArticles
            }
        }
    }
    
    var atPage: Int?
    
    var delegate: performNavigationDelegate?
    var url = "https://app.moccafeusa.com/api/v1/blogs/news_articles"
    var filePath = "/Library/Caches/news.txt"
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        retrieveArticle(page: 1)

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
            "subtitle": articles[indexPath.row].content ?? "",
            "image":  1//  data["image"] as? UIImage
            //"Coffee offers so many benefits already. Now we can add ‘cancer fighter’ to that list."
        ]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell else { return PostCell() }
        let data = cellData
        
        cell.configureWithData(data)
        let imageStringURL = "https://c2.staticflickr.com/8/7259/7520264210_0c98a6fab2_b.jpg"
        articles[indexPath.row].picUrl = imageStringURL
        if let imageURL = URL.init(string: imageStringURL) {
            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
            }
            cell.postImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if delegate != nil {
            delegate?.loadDetail!(article: articles[indexPath.row])
            
        }
    }
    
    func retrieveArticle(page: Int) {
        
        var json: JSON = [:]
        json["blog"] = ["pagina": page]

        self.apiHandler.retrieveArticles(url: self.url, json: json) {
            response, error in
                
            var jsonValue: JSON = [:] {
                didSet {
                    self.createArray(json: jsonValue, page: page)
                }
            }
            if response != nil {
                jsonValue = response!
                self.storeArticles(json: response!)
                
            } else if response == nil {
                jsonValue = self.retrieveStoredData() ?? [:]
            }
        }
    }
    
    func createArray(json: JSON, page: Int) {
        let articles = json["blog"]["articles"].arrayValue
        let pageRetrieved = json["blog"]["page"].int
        
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
                self.retrievedArticles.append(article)
            }
        }
    }
    
    func storeArticles(json: JSON) {
        
        let filePath = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(self.filePath)
        do {
            let data = try json.rawData()
            do {
                try data.write(to: filePath!, options: Data.WritingOptions.atomic)
            } catch { }
        } catch { }
    }
    
    func retrieveStoredData() -> JSON? {
        let filePath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(self.filePath)
        do {
            let data = try Data(contentsOf: filePath, options: Data.ReadingOptions.mappedIfSafe)
            let jsonData = JSON(data: data)
            return jsonData
        }
        catch { return nil }
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
        retrievedArticles.removeAll()
        retrieveArticle(page: 1)
        self.refreshControl!.endRefreshing()
    }
    


}
