//
//  ShopViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UIWebViewDelegate, SignUpTransitionDelegate {

    @IBAction func profileAction(_ sender: UIBarButtonItem) {
        loadProfile()
    }
    
    @IBOutlet var shopWebView: UIWebView!
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopWebView.delegate = self
        self.shopWebView.scalesPageToFit = true
        self.shopWebView.contentMode = UIViewContentMode.scaleAspectFit
        let url = URL(string: "https://github.myshopify.com/")
        let request = URLRequest(url: url!)
        shopWebView.loadRequest(request)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor(red:0.36, green:0.57, blue:0.02, alpha:1.0)

        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()

        // Do any additional setup after loading the view.
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadProfile() {
        if (UserDefaults.standard.value(forKey: "token") as? String) != nil {
            
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
            self.navigationController?.pushViewController(vc, animated:true)
        } else {
            let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }

    func signupDismissed() {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
   
}
