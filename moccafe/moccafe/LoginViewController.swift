//
//  LoginViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/24/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVFoundation



class LoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
   
    // MARK: - Class Constants and Variables
    
    var player = AVPlayer(playerItem: nil)
    let request = APICall()
    let myDefaults = UserDefaults.standard
    var delegate: SignUpTransitionDelegate?
    

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var mainScrollView: UIScrollView!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let filePath = Bundle.main.path(forResource: "MOV_2488", ofType: "mp4")
        let fileURL = URL(fileURLWithPath: filePath!)
        
        player = AVPlayer(url: fileURL)
        player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(playerItemDidReachEnd),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: self.player.currentItem)
        
        let videoLayer = AVPlayerLayer(player: player)
        videoLayer.frame = self.view.bounds
        self.view.backgroundColor = UIColor.clear
        
        videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.view.layer.insertSublayer(videoLayer, at: 0)
        
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
        player.play()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        player.pause()
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
        self.view.frame.origin.y = 0
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions
    
    func playerItemDidReachEnd(notification: NSNotification) {
        self.player.seek(to: kCMTimeZero)
        self.player.play()
    }
    
    @IBAction func showPassword(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func dismissLogin(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        var loginData: JSON = [:]
        
        loginData["email"].string = emailTextField.text
        loginData["password"].string = passwordTextField.text
        
        request.login(json: loginData) { json, error in
            
            if json != nil {
                if json!["status"].boolValue == false {
                    
                    let error = json!["errors"]["user_errors"].dictionaryObject?.first
                    let title = error?.key
                    let message = (error?.value as? [String])?.first
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .cancel) { Void in }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    
                }
                else if let token = json?["data"]["token"].string {
                    UserDefaults.standard.set(token, forKey: "token")
                    self.delegate?.signupDismissed()
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        }
    }
    
    @IBAction func cancelLogin(_ sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Keboard Notifications Methods
    
    func registerForKeyboardNotifications() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func deregisterFromKeyboardNotifications () -> Void {
        let center:  NotificationCenter = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else if self.view.frame.origin.y < 0 {
                self.view.frame.origin.y = 0
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    // Called when 'return' key pressed. return false to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.frame.origin.y = 0
        textField.resignFirstResponder()
        return true
    }
}
