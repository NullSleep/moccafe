//
//  MyTreeViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 7/7/17.
//  Copyright © 2017 moccafe. All rights reserved.
//


import UIKit
import SwiftyJSON
import SDWebImage
import AVKit
import AVFoundation
import HGPlaceholders

class MyTreeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, postCellTableViewDelegate, SignUpTransitionDelegate, UIScrollViewDelegate {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet var tableView: TableView!
    
    @IBOutlet var searchBarButton: UIBarButtonItem!
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var questionButton: UIButton!
    @IBOutlet var questionButtonItem: UIBarButtonItem!
    
    var articles = [Article]() {
        didSet {
            self.tableView.reloadData()
            refreshControl.endRefreshing()

        }
    }
    
    var scrollHeight = 0
    
    var filteredArticles = [Article]()
    
    var retrievedArticles = [Article]() {
        didSet {
            if !retrievedArticles.isEmpty {
                articles = retrievedArticles
            }
        }
    }
    
    let spinner = UIImageView(image: UIImage(named: "spinner"), highlightedImage: nil)
    
    
    var articleToSegue: Article?
    var atPage: Int?
    let apiHandler = APICall()
    
    var refreshControl = UIRefreshControl()
    
    let urlQuestions = "https://app.moccafeusa.com/api/v1/questions/tree_options"
    let urlArticles = "https://app.moccafeusa.com/api/v1/blogs/tree_articles"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        tableView.dataSource = self
        
        spinner.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        view.addSubview(spinner)
        startSpinning()
        
        tableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
  
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationItem.title = NSLocalizedString("My Tree", comment: "")
        
        
        questionButton.layer.borderColor = UIColor.white.cgColor
        questionButton.layer.cornerRadius = 12.5
        questionButton.layer.borderWidth = 1
        questionButton.frame.size = CGSize(width: 25, height: 25)
        questionButton.addTarget(self, action: #selector(loadQuestions), for: .touchUpInside)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 370
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1.0)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        retrievedArticles.removeAll()
        retrieveArticle(page: 1)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {

        tableView.setContentOffset(CGPoint(x: 0, y: scrollHeight), animated: true)
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollHeight = Int(scrollView.contentOffset.y)
    }
    
    // MARK: - Navigation Bar Actions
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItems = nil
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.titleView = searchController.searchBar
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
        self.navigationItem.rightBarButtonItems = [profileButton, questionButtonItem]
        self.navigationItem.hidesBackButton = false
        self.navigationItem.titleView = nil
        
    }
    
    func loadQuestions() {
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "contactUs") as! ContactUsViewController
        vc.calledFrom = urlQuestions
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    @IBAction func profileAction(_ sender: UIBarButtonItem) {
        loadProfile()
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as? MyTreeTableViewCell
        cell?.delegate = self
        
        let article: Article
        
        if searchController.isActive && searchController.searchBar.text != "" {
            article = filteredArticles[indexPath.row]
        } else {
            article = articles[indexPath.row]
        }
        
        //To Delete
        
//        article.picUrl = "https://c2.staticflickr.com/8/7259/7520264210_0c98a6fab2_b.jpg"
//        article.content = "Coffee offers so many benefits already. Now we can add ‘cancer fighter’ to that list."
//        article.title = "Coffee Drinkers May Have One Less Type Of Cancer To Worry About"
//        article.thumbUrl = ""//"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjhfpaXnErAFp2f6vcCEVsQv7dKQa5NfWcvOKyYr0pdLS59ryL"
//       article.videoUrl = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        
        
        let cellData: NSDictionary = [
            "date": article.created ?? "",
            "title": article.title ?? "",
            "subtitle": article.content ?? "",
            "picUrl": article.picUrl ?? "",
            "thumbUrl": article.thumbUrl ?? "",
            "videoUrl": article.videoUrl ?? "",
            "index": indexPath.row,
            "liked": article.liked ?? false
        ]
        
        
        cell?.configureWithData(cellData)
        
        return cell!
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searchController.isActive && searchController.searchBar.text != "" {
            articleToSegue = filteredArticles[indexPath.row]
        } else {
            articleToSegue = articles[indexPath.row]
        }
        performSegue(withIdentifier: "showDetail", sender: self)
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
        let url = urlArticles
        
        let token = (UserDefaults.standard.value(forKey: "token") as? String) ?? ""
        let headers = ["Authorization": token]

        apiHandler.retrieveArticles(url: url, json: json, headers: headers) { response, error in
            
            var jsonValue: JSON = [:] {
                didSet {
                    self.createArray(json: jsonValue, page: page) }
            }
            self.stopSpinning()
            
            if response != nil {
                jsonValue = response!
                self.storeArticles(json: response!)
            } else if response == nil {
                jsonValue = self.retrieveStoredData() ?? [:]
            }
          //  self.tableView.showLoadingPlaceholder()
        }
        

    }
    
    func createArray(json: JSON, page: Int) {
        
        let articles = json["articles"]["articles"].arrayValue
        let pageRetrieved = json["articles"]["page"].int
        
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
        
        let filePath = NSURL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("/Library/Caches/tree.txt")
        do {
            let data = try json.rawData()
            do {
                try data.write(to: filePath!, options: Data.WritingOptions.atomic)
            } catch { }
        } catch { }
    }
    
    func retrieveStoredData() -> JSON? {
        
        let filePath = URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("/Library/Caches/tree.txt")
        do {
            let data = try Data(contentsOf: filePath, options: Data.ReadingOptions.mappedIfSafe)
            let jsonData = JSON(data: data)
            if jsonData.isEmpty {
               
            }
            return jsonData
        }
        catch { return nil }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        retrievedArticles.removeAll()
        retrieveArticle(page: 1)
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.searchController.searchBar.resignFirstResponder()
        if let nextvc = segue.destination as? DetailViewController {
            nextvc.article = articleToSegue
        }
    }
    
    func playVideo(index: Int) {
        
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: .none)
        tableView.delegate?.tableView!(tableView, didSelectRowAt: IndexPath(row: index, section: 0))
        DispatchQueue.main.async {
            self.loadVideo()
        }
    }
    
    func loadVideo() {
        
        if let videoURL = URL(string: articleToSegue?.videoUrl ?? "") {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    func signupDismissed() {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startSpinning() {
        spinner.image = UIImage(named:"spinner")
        spinner.startRotating()
    }
    
    
    func stopSpinning() {
        spinner.stopRotating()
        spinner.image = UIImage(named:"spinner")
        spinner.isHidden = true
    }
    
    func handleSync() {
        startSpinning()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (3 * Double(NSEC_PER_SEC))) {
            self.stopSpinning()
        }
        
    }
    
}

extension MyTreeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

