//
//  LoginViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/24/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON


class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    let request = APICall()
    let myDefaults = UserDefaults.standard
    
    var profile:JSON = [:] {
        didSet {
            self.myDefaults.set(profile["name"].string, forKey: "userName")
            self.myDefaults.set(profile["email"].string, forKey: "userEmail")
            self.myDefaults.set(profile["city"].string, forKey: "userCity")
            self.myDefaults.set(profile["last_name"].string, forKey: "userLastName")
            self.myDefaults.set(profile["info"].string, forKey: "userInfo")
            self.myDefaults.set(profile["mobile"].string, forKey: "userMobile")
        }
    }

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var mainScrollView: UIScrollView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        for item in [emailTextField, passwordTextField] {
            item?.delegate = self
        }
        let myAttribute = [ NSForegroundColorAttributeName: UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.6) ]
        emailTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Insert email", comment: ""), attributes: myAttribute)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Insert password", comment: ""), attributes: myAttribute)
        passwordTextField.isSecureTextEntry = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.registerForKeyboardNotifications()
    }

    override func viewDidLayoutSubviews() {
        
        for item in [emailTextField, passwordTextField] {
            let subView = UIView(frame: CGRect(x: 0, y: 29, width: (item?.bounds.width)!, height: 0.5))
            subView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
            subView.alpha = 0.9
            item?.addSubview(subView)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    @IBAction func showPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        request.getProfile() {
            json, error in
            
            if json != nil {
                self.profile = json!["profile"]
                print("json response \(json!)")
            } else if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Private Methods
    
    func registerForKeyboardNotifications() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            print("HELLO")
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
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
}
