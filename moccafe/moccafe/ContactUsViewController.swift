//
//  ContactUsViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 6/1/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContactUsViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var emailLabel: UILabel!
    
    @IBOutlet var commentsLabel: UILabel!
    
    @IBOutlet var commentsField: UITextView!
    
    var json : JSON = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = json["name"].string
        emailLabel.text = json["email"].string
        commentsField.layer.borderColor = UIColor.darkGray.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func dismissKeyboard() {
        view.endEditing(true)
    }

}
