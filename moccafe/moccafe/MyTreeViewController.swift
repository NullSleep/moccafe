//
//  SecondViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyTreeViewController: UITableViewController {

    @IBOutlet var questionButton: UIButton!
    
    let apiHandler = APICall()
    var articles = [Article]()
    var atPage: Int?

    
    @IBAction func profileAction(_ sender: UIBarButtonItem) {
        loadProfile()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

        questionButton.layer.borderColor = UIColor.white.cgColor
        questionButton.layer.cornerRadius = 12.5
        questionButton.layer.borderWidth = 1
        questionButton.addTarget(self, action: #selector(loadQuestions), for: .touchUpInside)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 370
        tableView.tableFooterView = UIView()
        
        self.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        
        
        retrieveArticle(page: 1)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = false

    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as? MyTreeTableViewCell
        
        
        let cellData: NSDictionary = [
            "date": articles[indexPath.row].created ?? "",
            "title": articles[indexPath.row].title ?? "", //"Coffee Drinkers May Have One Less Type Of Cancer To Worry About",
            "subtitle": articles[indexPath.row].content ?? ""
            //"Coffee offers so many benefits already. Now we can add ‘cancer fighter’ to that list."
        ]
        
        
//        cell.textLabel?.text = profileOptions[indexPath.row]
//        if indexPath.row == 2 {
//            cell.accessoryType = .none
//        }
        cell?.configureWithData(cellData)

        return cell!
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadQuestions() {
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "contactUs") as! ContactUsViewController
        
        vc.calledFrom = "https://app.moccafeusa.com/api/v1/questions/tree_options"
        self.navigationController?.pushViewController(vc, animated:true)
        
        
    }
    
    func loadProfile() {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
        
        
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    func retrieveArticle(page: Int) {
        
        var json: JSON = [:]
        json["blog"] = ["pagina": page]
        let url = "https://app.moccafeusa.com/api/v1/blogs/tree_articles"
        
        apiHandler.retrieveArticles(url: url, json: json) {
            json, error in
            if json != nil {
                let articles = json!["articles"]["articles"].arrayValue
                let pageRetrieved = json!["articles"]["page"].int
                
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

    
    func handleRefresh(refreshControl: UIRefreshControl) {
        articles.removeAll()
        retrieveArticle(page: 1)
        refreshControl.endRefreshing()
    }


    
}

