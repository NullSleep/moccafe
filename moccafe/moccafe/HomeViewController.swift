//
//  FirstViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsViewController: UITableViewController {

    
    
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var blogButton: UIButton!
    
    @IBOutlet var viewPagesNavigation: UIView!
    
    @IBAction func newsClicked(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:0.36, green:0.76, blue:0.18, alpha:1.0)
        blogButton.backgroundColor = UIColor.clear
    }
    
    @IBAction func blogClicked(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:0.36, green:0.76, blue:0.18, alpha:1.0)
        newsButton.backgroundColor = UIColor.clear
        
        
        
          let pagevc = self.presentingViewController as? UIPageViewController
        let blogVC = storyboard?.instantiateViewController(withIdentifier: "BlogViewController")

        pagevc?.setViewControllers([blogVC!], direction: .forward, animated: true, completion: nil)
        
//        let parentVC = HomeViewController()
//        
//        
//        parentVC.showBlog(vc: blogVC!)
    //    if let superVC = self.parent as? HomeViewController {
            print("paretntttt")
//            let x = superVC.pageViewController(superVC.pageViewController, viewControllerAfter: superVC.viewControllerAtIndex(index: 1)!)
//            superVC.pageViewController.setViewControllers([superVC.viewControllerAtIndex(index: 1)!], direction: .forward, animated: true, completion: nil)
          //  superVC.pageViewController(page, viewControllerAfter: <#T##UIViewController#>)
            
//            superVC.pageViewController.setViewControllers([superVC.viewControllerAtIndex(index: 1)!], direction: .forward, animated: true, completion: nil)
//            superVC.pageViewController.show(superVC.viewControllerAtIndex(index: 1)!, sender: self)
       //     superVC.showBlog()
            
       // }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        newsClicked(newsButton)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        

         self.navigationItem.rightBarButtonItem = self.profileButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "home", for: indexPath) as! HomeCell
//        cell.feedtitle?.text = "title"
//        cell.feedtext?.text = "text"
   //     cell.feedimage?.image = UIImage(named: "mtabhome")
        return cell
     }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}



