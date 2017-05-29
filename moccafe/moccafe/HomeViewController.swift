//
//  FirstViewController.swift
//  moccafe
//
//  Created by Carlos Arenas on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    
    @IBOutlet var profileButton: UIBarButtonItem!
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var blogButton: UIButton!
    
    @IBOutlet var view2222: UIView!
    
    @IBAction func newsClicked(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:0.36, green:0.76, blue:0.18, alpha:1.0)
        blogButton.backgroundColor = UIColor(red:0.35, green:0.83, blue:0.15, alpha:1.0)
    }
    
    @IBAction func blogClicked(_ sender: UIButton) {
        sender.backgroundColor = UIColor(red:0.36, green:0.76, blue:0.18, alpha:1.0)
        newsButton.backgroundColor = UIColor(red:0.35, green:0.83, blue:0.15, alpha:1.0)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        newsClicked(newsButton)
        view2222.backgroundColor = UIColor(red:0.35, green:0.83, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.backgroundColor = UIColor(red:0.35, green:0.83, blue:0.15, alpha:1.0)
        navigationController?.navigationBar.shadowImage = navigationController?.navigationBar.shadowImage?.imageWithColor(color: UIColor(red:0.35, green:0.83, blue:0.15, alpha:1.0))

       

        
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

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
}
}

