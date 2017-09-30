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
    
    let spinner = UIImageView(image: UIImage(named: "spinner"), highlightedImage: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        
        shopWebView.delegate = self
        self.shopWebView.scalesPageToFit = true
        self.shopWebView.contentMode = UIViewContentMode.scaleAspectFit
        var url: URL?
        if Locale.preferredLanguages[0] == "en" {
            url = URL(string: "https://moccafeusa.com/collections/all")
        } else {
            url = URL(string: "https://moccafe.jp/collections/all")
        }
        let request = URLRequest(url: url!)
        shopWebView.loadRequest(request)

        view.addSubview(spinner)
        startSpinning()

        // Do any additional setup after loading the view.
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopSpinning()
        spinner.isHidden = true
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
    
    func startSpinning() {
        spinner.image = UIImage(named:"spinner")
        spinner.startRotating()
    }
    
    
    func stopSpinning() {
        spinner.stopRotating()
        spinner.image = UIImage(named:"spinner")
    }
    
    func handleSync() {
        startSpinning()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (3 * Double(NSEC_PER_SEC))) {
            self.stopSpinning()
        }
    
    }
}
