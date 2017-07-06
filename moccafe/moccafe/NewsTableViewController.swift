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
import AVKit
import AVFoundation

class NewsTableViewController: UITableViewController, IndicatorInfoProvider, postCellTableViewDelegate {
    
    var searchText: String? {
        didSet {
        
        }
    }
    let apiHandler = APICall()
    var atPage: Int?
    var delegate: performNavigationDelegate?
    
    var filteredArticles = [Article]()
    
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
        tableView.separatorStyle = .none
//        tableView.separatorColor = UIColor.lightGray
//        tableView.separatorInset = UIEdgeInsets.zero
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if delegate?.searchController.searchBar.text != "" {
            return filteredArticles.count
        }
        return articles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        article.picUrl = "https://c2.staticflickr.com/8/7259/7520264210_0c98a6fab2_b.jpg"

        article.title = "Coffee Drinkers May Have One Less Type Of Cancer To Worry About"
        article.content = "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. Est antiopam facilisis adolescens id. Pri graecis suscipiantur no, in usu altera virtute, eam ei enim wisi. Pro probo vidisse appetere te, odio mollis et mei. Epicurei laboramus mei ut, usu ea affert quaerendum. Delicata urbanitas has an, eum eu omnium dissentiunt. Laoreet veritus temporibus est ne, at vero eirmod aperiri per. Quis volutpat scripserit mel at, duo fugit vidisse admodum ne. Ei mea noster quaestio, duo ne dicat mundi tantas. Nisl assum bonorum te usu, doming corrumpit ei nam. Ne sed suscipit argumentum. Paulo everti suscipiantur in vel, cu mei iisque propriae corrumpit. Ex vix prompta forensibus, ea movet incorrupte elaboraret eos, etiam eripuit vix an. Quo te ignota phaedrum appellantur, in pri justo partiendo adolescens, mea agam democritum ex. Alii invidunt maluisset sit an. An nec labores perpetua. Ex ridens aperiam vix, vel ex alia nemore rationibus. Etiam tincidunt intellegam ut cum. Dico essent vim et, vis sale debet iriure ea, eu est aeterno scribentur. Ne unum scripserit duo. Ad eos tincidunt contentiones, no zril urbanitas argumentum usu. Ferri oblique tacimates ne nec, vero mollis probatus vis ne. Vis at qualisque definitiones."
        
        article.thumbUrl = ""//"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjhfpaXnErAFp2f6vcCEVsQv7dKQa5NfWcvOKyYr0pdLS59ryL"
        article.videoUrl = ""//"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"


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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (delegate?.searchController.isActive)! && delegate?.searchController.searchBar.text != "" {
            articleToSegue = filteredArticles[indexPath.row]
            delegate?.loadDetail!(article: articleToSegue!)

        } else {
            articleToSegue = articles[indexPath.row]
            delegate?.loadDetail!(article: articleToSegue!)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
        self.refreshControl!.endRefreshing()
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
        
        let videoURL = URL(string: (articleToSegue?.videoUrl)!)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}
