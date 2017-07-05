//
//  SignUpViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/25/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON


class SignUpViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var delegate: SignUpTransitionDelegate?
    
    let request = APICall()
    let myDefaults = UserDefaults.standard
    
    /*
    var profile:JSON = [:] {
        didSet {
            self.myDefaults.set(profile["name"].string, forKey: "userName")
            self.myDefaults.set(profile["email"].string, forKey: "userEmail")
            self.myDefaults.set(profile["city"].string, forKey: "userCity")
            self.myDefaults.set(profile["last_name"].string, forKey: "userLastName")
            self.myDefaults.set(profile["info"].string, forKey: "userInfo")
            self.myDefaults.set(profile["mobile"].string, forKey: "userMobile")
        }
    } */
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        for item in [emailTextField, passwordTextField, nameTextField] {
            item?.delegate = self
        }
        let myAttribute = [ NSForegroundColorAttributeName: UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.6) ]
        nameTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Insert name", comment: ""), attributes: myAttribute)
        emailTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Insert email", comment: ""), attributes: myAttribute)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Insert password", comment: ""), attributes: myAttribute)
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewDidLayoutSubviews() {
        
        for item in [emailTextField, passwordTextField, nameTextField] {
            
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
    
    @IBAction func showPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        var signupData: JSON = [:]
        
        signupData["name"].string = nameTextField.text
        signupData["email"].string = emailTextField.text
        signupData["password"].string = passwordTextField.text

        //if token -> save token***
        
        request.signup(json: signupData) {
            _ in
            self.delegate?.signupDismissed()
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
      
        /*
         request.getProfile() {
            json, error in
            
            if json != nil {
                self.profile = json!["profile"]
                print("json response \(json!)")
            } else if error != nil {
                print(error!.localizedDescription)
            }
        } 
         */
    }
    
    @IBAction func existingAccount(_ sender: UIButton) {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.delegate = self.delegate
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func cancelSignup(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)

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
