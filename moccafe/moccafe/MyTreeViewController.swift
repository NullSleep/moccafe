//
//  SecondViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class MyTreeViewController: UITableViewController {

    @IBOutlet var questionButton: UIButton!
    
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
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath)
        
//        cell.textLabel?.text = profileOptions[indexPath.row]
//        if indexPath.row == 2 {
//            cell.accessoryType = .none
//        }
        return cell
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



    
}

