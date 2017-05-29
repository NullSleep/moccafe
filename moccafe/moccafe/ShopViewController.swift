//
//  ShopViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet var shopWebView: UIWebView!
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shopWebView.delegate = self
        let url = URL(string: "https://www.simplifiedios.net")
        let request = URLRequest(url: url!)
        shopWebView.loadRequest(request)
        activityIndicator.center = CGPoint(x: view.bounds.size.width/2, y: view.bounds.size.height/2)
        activityIndicator.color = UIColor(red:0.35, green:0.83, blue:0.15, alpha:1.0)

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
