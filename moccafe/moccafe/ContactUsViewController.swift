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
    
    let apiHandler = APICall()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = json["name"].string
        emailLabel.text = json["email"].string
        commentsField.layer.borderColor = UIColor.darkGray.cgColor
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        apiHandler.getList { json, error in
            print("json response get list \(json)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitQuestion(_ sender: UIButton) {
    
        if checkFields() {
            var json: JSON = [:]
            var params = [String: Any]()
        
            params["name"] = nameLabel.text
            params["email"] = emailLabel.text
            params["phone"] = "987345"
            params["title"] = "Pregunta para el programa"
            params["content"] = commentsField.text
            params["question_type_id"] = 1

            json["question"] = JSON(params)
                
            apiHandler.postQuestion(json: json) {
            json, error in
                print("respomse post question\(json ?? "")")
            }
        } else {
            let alertView = UIAlertController(title: "Error", message: "Required fields must be filled out before proceeding", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { Void in }
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func checkFields() -> Bool {
        guard (nameLabel.text?.isEmpty == false), (emailLabel.text?.isEmpty == false), (commentsField.text.isEmpty == false) else { return false }
        return true
    }
    
    func retrieveArticle() {
        var json: JSON = [:]
        
        json["blog"] = ["pagina": 1]
        
        apiHandler.retrieveArticles(json: json) {
            json, error in
            print(json)
        }
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
