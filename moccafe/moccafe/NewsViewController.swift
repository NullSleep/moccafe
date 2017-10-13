//
//  NewsViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 7/7/17.
//  Copyright © 2017 moccafe. All rights reserved.
//


import UIKit
import XLPagerTabStrip
import SwiftyJSON
import AVKit
import AVFoundation

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IndicatorInfoProvider, postCellTableViewDelegate {
    
    var searchText: String? {
        didSet {
            
        }
    }
    
    let apiHandler = APICall()
    var atPage: Int?
    var delegate: performNavigationDelegate?
    
    var filteredArticles = [Article]()
    
    var tableView = UITableView()
    
    var articles = [Article]() {
        didSet { self.tableView.reloadData() }
    }
    
    var retrievedArticles = [Article]() {
        
        didSet {
            if !retrievedArticles.isEmpty {
                articles = retrievedArticles
            }
        }
    }
    
    var url = "https://app.moccafeusa.com/api/v1/blogs/news_articles"
    var filePath = "/Library/Caches/news.txt"
    
    let cellIdentifier = "postCell"
    var blackTheme = false
    var itemInfo = IndicatorInfo(title: "View")
    
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.clipsToBounds = true
       // tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.bounds.height))
        self.view.addSubview(tableView)

        let top = NSLayoutConstraint(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: topLayoutGuide, attribute: .top, multiplier: 1, constant: 10)
        
        let bottom = NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: bottomLayoutGuide, attribute: .top, multiplier: 1, constant: 2)
        
        let width = NSLayoutConstraint(item: self.tableView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0)
        
        let leading = NSLayoutConstraint(item: self.tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0)

        self.view.addConstraints([top, bottom, width, leading])
        
        self.tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 370
        tableView.register(UINib(nibName: "PostCell", bundle: Bundle.main), forCellReuseIdentifier: cellIdentifier)
        tableView.separatorStyle = .none

        tableView.tableFooterView = UIView()
        self.view.backgroundColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1.0)
        tableView.backgroundColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1.0)

        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl!)
        self.refreshControl!.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        retrievedArticles.removeAll()
        retrieveArticle(page: 1)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if (delegate?.searchController.searchBar.text != "") {
            
            DispatchQueue.main.async {
                self.delegate?.searchController.searchBar.becomeFirstResponder()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if delegate?.searchController.searchBar.text != "" {
            return filteredArticles.count
        }
        return articles.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PostCell else { return PostCell() }
        
        cell.backgroundColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1.0)
        cell.delegate = self
        
        let article: Article
        
        if delegate?.searchController.searchBar.text != "" && !filteredArticles.isEmpty {
            article = filteredArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
        
        //To Delete
//        if indexPath.row == 1 {
//            
//        article.picUrl = "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F31802497%2F178571484211%2F1%2Foriginal.jpg?w=1000&rect=0%2C0%2C2160%2C1080&s=35a5cb2089b503631b5631400deba8f4"
//        
//        article.title = "Coffee Drinkers May Have One Less Type Of Cancer To Worry About"
//        article.content = "Coffee offers so many benefits already. Now we can add ‘cancer fighter’ to that list."
//    }
//    
//        article.thumbUrl = ""//"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjhfpaXnErAFp2f6vcCEVsQv7dKQa5NfWcvOKyYr0pdLS59ryL"
//        article.videoUrl = ""//"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
//    
//    
//        if indexPath.row == 0 {
//        article.picUrl = "https://img.evbuc.com/https%3A%2F%2Fcdn.evbuc.com%2Fimages%2F31802001%2F178571484211%2F1%2Foriginal.jpg?w=1000&rect=0%2C0%2C2160%2C1080&s=24b46ab16de8b230e06277500dd27042"
//            article.title = "Italy's Coffee Culture Brims With Rituals And Mysterious Rules"
//            article.content = "Coffee — it's something many can't start the day without. In Italy, it is a cultural mainstay, and the country is perhaps the beverage's spiritual home."
//        }
        //
        
        let cellData: NSDictionary = [
            "date": article.created ?? "",
            "title": article.title ?? "",
            "subtitle": article.content ?? "",
            "picUrl":  article.picUrl ?? "",
            "thumbUrl": article.thumbUrl ?? "",
            "videoUrl": article.videoUrl ?? "",
            "index": indexPath.row,
            "liked": article.liked ?? false
        ]
        let data = cellData
        cell.configureWithData(data)
        
        return cell
    }
    
    var articleToSegue: Article?
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (delegate?.searchController.isActive)! && delegate?.searchController.searchBar.text != "" {
            articleToSegue = filteredArticles[indexPath.row]
            delegate?.loadDetail!(article: articleToSegue!)
            
        } else {
            articleToSegue = articles[indexPath.row]
            delegate?.loadDetail!(article: articleToSegue!)
        }
    }
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == self.articles.count-1 {
            if atPage != nil {
                retrieveArticle(page: atPage!+1)
            }
        }
    }
    
    
    // MARK: - Retrieve API Data and Populate Content
    
    func retrieveArticle(page: Int) {
        
        var json: JSON = [:]
        json["blog"] = ["pagina": page]
        
        self.apiHandler.retrieveArticles(url: self.url, json: json, headers: nil) {
            response, error in
            
            var jsonValue: JSON = [:] {
                didSet {
                    self.createArray(json: jsonValue, page: page)
                    
                }
            }
            self.delegate?.stopSpinning!()

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
                article.thumbUrl = item["thumb_url"].string
                article.picUrl = item["picture_url"].string
                article.liked = item["liked"].bool
                article.title = item["title"].string
                article.videoUrl = item["video_url"].string
                self.retrievedArticles.append(article)
            }
        }
        
    }
    
    // MARK: - Manage Cache
    
    func storeArticles(json: JSON) {
        
        let filePath = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent(self.filePath)
        do {
            let data = try json.rawData()
            do { try data.write(to: filePath!, options: Data.WritingOptions.atomic) } catch { }
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
    
    // MARK: - IndicatorInfoProvider
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        retrievedArticles.removeAll()
        retrieveArticle(page: 1)
        refreshControl.endRefreshing()

    }
    
    // MARK: - PostCellTableViewDelegate
    
    func playVideo(index: Int) {
        
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        DispatchQueue.main.async {
            self.loadVideo()
        }
    }
    
    func loadVideo() {
        
        if let videoURL = URL(string: (articleToSegue?.videoUrl)!) {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
}
