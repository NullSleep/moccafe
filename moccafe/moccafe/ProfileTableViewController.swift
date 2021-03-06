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

    let profileOptions = ["Edit Profile", "Contact us", "Logout"]
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    let request = APICall()
    var keys: [Any]?
    
    var profile:JSON = [:] {
        didSet {
            nameLabel.text = profile["name"].string
            emailLabel.text = profile["email"].string
            cityLabel.text = profile["city"].string

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

        self.tableView.tableFooterView = UIView()
        

            request.getProfile() {
                json, error in
                print("json response \(json)")
                if json != nil {
                    self.profile = json!["profile"]
                }
            }


        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = profileOptions[indexPath.row]

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
        
    }
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditProfileTableViewController {
            destination.profileData = profile
        }
    }
 

}
