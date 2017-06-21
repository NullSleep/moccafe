//
//  HomeViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 6/3/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

import XLPagerTabStrip

class HomeViewController: ButtonBarPagerTabStripViewController, performNavigationDelegate {
    
    let graySpotifyColor = UIColor(red: 21/255.0, green: 21/255.0, blue: 24/255.0, alpha: 1.0)
    let darkGraySpotifyColor = UIColor(red: 19/255.0, green: 20/255.0, blue: 20/255.0, alpha: 1.0)
    var articleToSegue: Article?

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
        articleToSegue = article
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextvc = segue.destination as? DetailViewController {
            nextvc.article = articleToSegue
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
