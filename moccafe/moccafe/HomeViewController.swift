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
    
    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    
    @IBOutlet var searchBarButton: UIBarButtonItem!
    @IBOutlet var profileButton: UIBarButtonItem!
    
    var articleToSegue: Article?
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        }
        super.viewDidLoad()
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        self.definesPresentationContext = false
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.becomeFirstResponder()

    }
    
    func startWithSearch() {
        searchButtonTapped(searchBarButton)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.navigationItem.leftBarButtonItem = searchBarButton
        self.navigationItem.rightBarButtonItem = profileButton
        self.navigationItem.hidesBackButton = false
        self.navigationItem.titleView = nil
    }
    
    // MARK: - PagerTabStripDataSource
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child_1 = NewsTableViewController(style: .plain, itemInfo: IndicatorInfo(title: "NEWS"))
        child_1.blackTheme = true
        child_1.delegate = self
        child_1.url = "https://app.moccafeusa.com/api/v1/blogs/news_articles"
        child_1.filePath = "/Library/Caches/news.txt"
        
        let child_2 = NewsTableViewController(style: .plain, itemInfo: IndicatorInfo(title: "BLOG"))
        child_2.blackTheme = true
        child_2.delegate = self
        child_2.url = "https://app.moccafeusa.com/api/v1/blogs/articles"
        child_2.filePath = "/Library/Caches/blog.txt"
        
        return [child_1, child_2]
    }
    
    func loadDetail(article: Article) {
        
     //   self.searchBarCancelButtonClicked(searchController.searchBar)
        articleToSegue = article
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        
        let vc = viewControllers[self.currentIndex] as? NewsTableViewController
        vc?.filteredArticles = (vc?.articles.filter { article in
            return (article.title?.lowercased().contains(searchText.lowercased()))!
            })!
        vc?.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.searchController.searchBar.resignFirstResponder()

        if let nextvc = segue.destination as? DetailViewController {
            nextvc.article = articleToSegue
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        searchController.searchBar.isHidden = true
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
