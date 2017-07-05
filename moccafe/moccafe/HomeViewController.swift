//
//  HomeViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 6/3/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController, performNavigationDelegate, UISearchBarDelegate {
    
    static let ReceivedBlogNotification = "ReceivedBlogNotification"
    static let ReceivedNewsNotification = "ReceivedNewsNotification"
    
    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
    @IBOutlet var searchBarButton: UIBarButtonItem!
    @IBOutlet var profileButton: UIBarButtonItem!
    
    var articleToSegue: Article?
    var searchText: String?

    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.receivedBlog(_:)), name: NSNotification.Name(rawValue: HomeViewController.ReceivedBlogNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.receivedNews(_:)), name: NSNotification.Name(rawValue: HomeViewController.ReceivedNewsNotification), object: nil)
        
        buttonBarView.frame.size.height = 50

        
        settings.style.buttonBarBackgroundColor = graySpotifyColor
        settings.style.buttonBarItemBackgroundColor = graySpotifyColor
        settings.style.selectedBarBackgroundColor = UIColor(red: 33/255.0, green: 174/255.0, blue: 67/255.0, alpha: 1.0)
        settings.style.buttonBarItemFont = UIFont(name: "HelveticaNeue-Light", size:14) ?? UIFont.systemFont(ofSize: 14)
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .black
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 20
        settings.style.buttonBarRightContentInset = 20
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            
            guard changeCurrentIndex == true else {
                return
            }
            oldCell?.label.textColor = UIColor(red: 138/255.0, green: 138/255.0, blue: 144/255.0, alpha: 1.0)
            newCell?.label.textColor = .white
            self.searchController.isActive = false
            self.cancelSearch()
        }
        super.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func receivedBlog(_ notification: Notification) {
        DispatchQueue.main.async {
            self.moveToViewController(at: 1)
        }
    }
    
    func receivedNews(_ notification: Notification) {
        DispatchQueue.main.async {
            self.moveToViewController(at: 0)
        }
    }

    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        self.definesPresentationContext = true
        self.navigationController?.definesPresentationContext = true

        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()
    }
    
    func startWithSearch() {
        searchButtonTapped(searchBarButton)
    }
    
    func cancelSearch() {
        self.definesPresentationContext = true
        self.navigationController?.definesPresentationContext = true
        searchBarCancelButtonClicked(searchController.searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.leftBarButtonItem = searchBarButton
        self.navigationItem.rightBarButtonItem = profileButton
        self.navigationItem.hidesBackButton = false
        self.navigationItem.titleView = nil
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = NewsTableViewController(style: .plain, itemInfo: IndicatorInfo(title: NSLocalizedString("NEWS", comment: "")))
        child_1.blackTheme = true
        child_1.delegate = self
        child_1.url = "https://app.moccafeusa.com/api/v1/blogs/news_articles"
        child_1.filePath = "/Library/Caches/news.txt"
        child_1.searchText = searchText
        
        let child_2 = NewsTableViewController(style: .plain, itemInfo: IndicatorInfo(title: NSLocalizedString("BLOG", comment: "")))
        child_2.blackTheme = true
        child_2.delegate = self
        child_2.url = "https://app.moccafeusa.com/api/v1/blogs/articles"
        child_2.filePath = "/Library/Caches/blog.txt"
        child_2.searchText = searchText

        
        return [child_1, child_2]
    }
    
    func loadDetail(article: Article) {
        
        articleToSegue = article
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "detailVC") as! DetailViewController
        vc.article = articleToSegue
        if let searchText = searchController.searchBar.text {
            vc.searchText = searchText
        }
        self.navigationController?.pushViewController(vc, animated:true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchController.dismiss(animated: true, completion: nil)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        let vc = viewControllers[self.currentIndex] as? NewsTableViewController
        vc?.filteredArticles = (vc?.articles.filter { article in
            return (article.title?.lowercased().contains(searchText.lowercased()))!
            })!
        vc?.tableView.reloadData()
    }
    
    
    func updateSearch() {
        
        self.updateSearchResults(for: self.searchController)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
