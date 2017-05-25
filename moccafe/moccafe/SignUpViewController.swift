//
//  SignUpViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/25/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    @IBAction func showPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for item in [emailTextField, passwordTextField, nameTextField] {
            item?.delegate = self
        }
        let myAttribute = [ NSForegroundColorAttributeName: UIColor(red:0.94, green:0.94, blue:0.96, alpha:0.6) ]
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Insert name", attributes: myAttribute)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Insert email", attributes: myAttribute)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Insert password", attributes: myAttribute)
        
        
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
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
