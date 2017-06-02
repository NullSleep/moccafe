//
//  PageViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/26/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    var pageViewController: UIPageViewController!
    
    let pages = ["HomeViewController", "BlogViewController"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PageViewController") {
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource = self
            pageViewController.delegate = self
            
            pageViewController.setViewControllers([viewControllerAtIndex(index: 0)!], direction: .forward, animated: true, completion: nil)
            
        }
        
        
        
       
        

        // Do any additional setup after loading the view.
    }
    
    func showBlog(vc: UIViewController) {
        self.pageViewController.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
    }
    
    func showNews() {
        self.pageViewController.setViewControllers([viewControllerAtIndex(index: 0)!], direction: .reverse, animated: true, completion: nil)
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.index(of: viewController.restorationIdentifier!) {
            if index > 0 {
                return viewControllerAtIndex(index: index-1)
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.index(of: viewController.restorationIdentifier!) {
            if index < pages.count-1 {
                return viewControllerAtIndex(index: index+1)
            }
        }
        return nil 
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewControllerAtIndex(index: Int) -> UIViewController? {
        let vc = storyboard?.instantiateViewController(withIdentifier: pages[index])
        return vc
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


