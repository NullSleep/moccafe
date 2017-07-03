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
    
    var calledFrom = "https://app.moccafeusa.com/api/v1/questions/support_options"
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var commentsField: UITextView!
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var questionTypeButton: UIButton!
    @IBOutlet var separatorView: UIView!
    
    var json : JSON = [:]
    
    let apiHandler = APICall()
    
    var typeOptions = ["":""] {
        didSet {
            questionTypeButton.setTitle(self.typeOptions.first?.value, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.isHidden = true
        
        nameTextField.text = (UserDefaults.standard.value(forKey: "userName") as? String) ?? json["name"].string
        emailTextField.text = (UserDefaults.standard.value(forKey: "userEmail") as? String) ?? json["email"].string
        phoneTextField.text = (UserDefaults.standard.value(forKey: "userMobile") as? String) ?? json["mobile"].string
        commentsField.layer.borderColor = UIColor.lightGray.cgColor
        commentsField.layer.borderWidth = 0.5
        commentsField.layer.cornerRadius = 5
        questionTypeButton.layer.cornerRadius = 5
        questionTypeButton.layer.borderColor = UIColor.lightGray.cgColor
        questionTypeButton.addTarget(self, action: #selector(changeType), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        getQuestionTypes()
        setLabels()
    }
    
    func getQuestionTypes() {
    
        apiHandler.getList(url: calledFrom) { json, error in
            if json != nil {
                
                var options = [String: String]()
                let optionList = json!["options"].arrayValue
                print(optionList)
                for item in optionList {
                    let idAsArray = Array((item.dictionaryObject ?? ["":""]).keys)
                    let id = idAsArray[0]
                    options[id] = item[id].string
                }
                self.typeOptions = options
            }
        }
    }
    
    func changeType() {
        
        let alertView = UIAlertController(title: NSLocalizedString("Choose the type of question", comment: ""), message: nil, preferredStyle: .actionSheet)
        
        for item in typeOptions {
            let action = UIAlertAction(title: "\(item.value)", style: .default) { Void in
                self.questionTypeButton.setTitle(item.value, for: .normal)
            }
            alertView.addAction(action)
        }
        let action = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .destructive) { Void in }
        alertView.addAction(action)
        self.present(alertView, animated: true, completion: nil)
    }
    
    
    
    
    func setLabels() {
        for textField in [nameTextField, emailTextField, phoneTextField] {
            textField?.leftViewMode = UITextFieldViewMode.always
            textField?.contentVerticalAlignment = UIControlContentVerticalAlignment.center
            textField?.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        }
        
        nameTextField?.leftView = createLeftLabel(name: NSLocalizedString("NAME", comment: ""))
        emailTextField?.leftView = createLeftLabel(name: NSLocalizedString("EMAIL", comment: ""))
        phoneTextField?.leftView = createLeftLabel(name: NSLocalizedString("PHONE", comment: ""))
        
    }
    
    func createLeftLabel(name: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: 60, height: 26))
        label.text = name
        label.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightMedium)
    
        label.textColor = UIColor.darkGray
        return label
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submitQuestion(_ sender: UIButton) {
    
        if checkFields() {
            var json: JSON = [:]
            var params = [String: Any]()
        
            params["name"] = nameTextField.text
            params["email"] = emailTextField.text
            params["phone"] = phoneTextField.text
            params["title"] = titleTextField.text
            params["content"] = commentsField.text
            if questionTypeButton.titleLabel?.text != NSLocalizedString("Choose Type", comment: "") {
                let key = typeOptions.keysForValue(value:(questionTypeButton.titleLabel?.text)!)
                params["question_type_id"] = key[0]
            }

            json["question"] = JSON(params)
            apiHandler.postQuestion(json: json) {
            json, error in
                if json != nil {
                    let alertView = UIAlertController(title: NSLocalizedString("Success", comment: ""), message: NSLocalizedString("Thanks for contacting us, will reply to you shortly", comment: ""), preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { Void in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertView.addAction(action)
                    self.present(alertView, animated: true, completion: nil)
                }
                else {
                    let alertView = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Please check your Internet connection", comment: ""), preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { Void in
                    }
                    alertView.addAction(action)
                    self.present(alertView, animated: true, completion: nil)
                }
                
            }
        } else {
            let alertView = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("Required fields must be filled out before proceeding", comment: ""), preferredStyle: .alert)
            let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { Void in }
            alertView.addAction(action)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    func checkFields() -> Bool {
        guard (nameTextField.text?.isEmpty == false), (emailTextField.text?.isEmpty == false), (commentsField.text.isEmpty == false), (titleTextField.text?.isEmpty == false) else { return false }
        return true
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


