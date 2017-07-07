//
//  VideosViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 7/7/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SwiftyJSON
import SDWebImage




class VideosViewController: UIViewController, performNavigationDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, SignUpTransitionDelegate {
    
    var searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var searchBarButton: UIBarButtonItem!
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var questionButtonItem: UIBarButtonItem!
    @IBOutlet var questionButton: UIButton!
    
    var filteredArticles = [Article]()
    
    
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
    
    @IBAction func profileAction(_ sender: UIBarButtonItem) {
        loadProfile()
    }
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        tableView.addSubview(refreshControl)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        questionButton.layer.borderColor = UIColor.white.cgColor
        questionButton.layer.cornerRadius = 12.5
        questionButton.layer.borderWidth = 1
        questionButton.addTarget(self, action: #selector(loadQuestions), for: .touchUpInside)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 370
        tableView.tableFooterView = UIView()

        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        //tableView.reloadData()
        retrieveArticle(page: 1)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredArticles.count
        }
        return articles.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? VideoTableViewCell
        cell?.delegate = self
        
        let article: Article
        
        if searchController.isActive && searchController.searchBar.text != "" {
            article = filteredArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
        
        let cellData: NSDictionary = [
            "date": article.created ?? "",
            "title": article.title ?? "", //"Coffee Drinkers May Have One Less Type Of Cancer To Worry About",
            "subtitle": article.content ?? "",
            //"Coffee offers so many benefits already. Now we can add ‘cancer fighter’ to that list."
            "picUrl":  article.picUrl ?? "",
            "thumbUrl": article.thumbUrl ?? "",
            "videoUrl": article.videoUrl ?? "",
            "index": indexPath.row,
            "liked": article.liked ?? false
        ]
        
        cell?.configureWithData(cellData)
        
        return cell!
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadVideo()
    }
    
    
    func loadVideo() {
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    // MARK: - Navigation Bar Actions
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = true
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredArticles = articles.filter { article in
            return (article.title?.lowercased().contains(searchText.lowercased()))!
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.leftBarButtonItem = searchBarButton
        self.navigationItem.rightBarButtonItems = [questionButtonItem, profileButton]
        self.navigationItem.hidesBackButton = false
        self.navigationItem.titleView = nil
    }
    
    func loadQuestions() {
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "contactUs") as! ContactUsViewController
        
        vc.calledFrom = "https://app.moccafeusa.com/api/v1/questions/video_options"
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    func loadProfile() {
        if (UserDefaults.standard.value(forKey: "token") as? String) != nil {
            
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
            self.navigationController?.pushViewController(vc, animated:true)
        } else {
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func retrieveArticle(page: Int) {
        
        var json: JSON = [:]
        json["blog"] = ["pagina": page]
        let url = "https://app.moccafeusa.com/api/v1/blogs/video_articles"
        
        apiHandler.retrieveArticles(url: url, json: json) {
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
        
        let filePath = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("/Library/Caches/videos.txt")
        do {
            let data = try json.rawData()
            do {
                try data.write(to: filePath!, options: Data.WritingOptions.atomic)
            } catch { }
        } catch { }
    }
    
    func retrieveStoredData() -> JSON? {
        let filePath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("/Library/Caches/videos.txt")
        do {
            let data = try Data(contentsOf: filePath, options: Data.ReadingOptions.mappedIfSafe)
            let jsonData = JSON(data: data)
            return jsonData
        }
        catch {
            return nil
        }
    }
    
    
     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.articles.count-1 {
            if atPage != nil {
                retrieveArticle(page: atPage!+1)
            }
        }
    }
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        retrievedArticles.removeAll()
        retrieveArticle(page: 1)
        refreshControl.endRefreshing()
    }
    
    func signupDismissed() {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension VideosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
