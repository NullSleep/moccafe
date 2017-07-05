//
//  ProfileTableViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/31/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfileTableViewController: UITableViewController {

    let profileOptions = [NSLocalizedString("Edit Profile", comment: ""), NSLocalizedString("Contact us", comment: ""), NSLocalizedString("Logout", comment: "")]
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    let request = APICall()
    var keys: [Any]?
    
    var profile:JSON = [:] {
        didSet {
            nameLabel.text = profile["name"].string ?? nameLabel.text
            emailLabel.text = profile["email"].string ?? emailLabel.text
            cityLabel.text = profile["city"].string ?? cityLabel.text
            
            UserDefaults.standard.set(profile["name"].string, forKey: "userName")
            UserDefaults.standard.set(profile["email"].string, forKey: "userEmail")
            UserDefaults.standard.set(profile["city"].string, forKey: "userCity")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
            request.getProfile() {
                json, error in
                
                if json != nil {
                    self.profile = json!["profile"]
                    print("json response \(json!)")
                } else if error != nil {
                    print(error!.localizedDescription)
                }
            }
            self.clearsSelectionOnViewWillAppear = true
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tableView.tableFooterView = UIView()
        
        nameLabel.text = (UserDefaults.standard.value(forKey: "userName") as? String) ?? NSLocalizedString("Name", comment: "")
        emailLabel.text = UserDefaults.standard.value(forKey: "userEmail") as? String ?? NSLocalizedString("Email", comment: "")
        cityLabel.text = UserDefaults.standard.value(forKey: "userCity") as? String ?? NSLocalizedString("City", comment: "")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return profileOptions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileOptionsCell", for: indexPath)
        
        cell.textLabel?.text = profileOptions[indexPath.row]
        if indexPath.row == 2 {
            cell.accessoryType = .none
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
 
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
 
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "showEdit", sender: self)
        }
        if indexPath.row == 1 {
            performSegue(withIdentifier: "showContactUs", sender: self)
        }
        if indexPath.row == 2 {
            UserDefaults.standard.removeObject(forKey: "token")
            self.navigationController?.popViewController(animated: true)
        }
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditProfileTableViewController {
            destination.profileData = profile
        }
        if let destination = segue.destination as? ContactUsViewController {
            destination.json = profile
        }
    }
 

}
