//
//  AppDelegate.swift
//  moccafe
//
//  Created by Carlos Arenas on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import UserNotifications
import SwiftyJSON


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let request = APICall()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = UIColor(red:0.26, green:0.12, blue:0.08, alpha:1.0)
        
        UINavigationBar.appearance().shadowImage = UIImage()
        UIApplication.shared.statusBarStyle = .lightContent
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName : UIFont.boldSystemFont(ofSize: 22)]
        } 
        
        Fabric.with([Crashlytics.self])
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            if let category = (aps["category"] as? String) {
            var index = Int()
            switch category {
                case "News": index = 0
                case "Blog": index = 0
                NotificationCenter.default.post(name: Notification.Name(rawValue: HomeViewController.ReceivedBlogNotification), object: self)
                case "Tree": index = 1
                case "Video": index = 2
            default: break
            }
                (window?.rootViewController as? UITabBarController)?.selectedIndex = index
            }
        }
        registerForPushNotifications()
        request.getArticleUrl { json, error in
            if (json != nil) {
                UserDefaults.standard.set((json!["url"].string ?? "https://moccafeusa.com/collections/all"), forKey: "storeUrl")
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            
            guard granted else { return }
            print("granted")
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        var json: JSON = [:]
        json["customer"] = ["the_token": token]
        
        request.storeToken(json: json) { json, error in
           
        }
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        let aps = userInfo["aps"] as! [String: AnyObject]
        if let category = (aps["category"] as? String) {
            var index = Int()
            switch category {
            case "News": index = 0
                NotificationCenter.default.post(name: Notification.Name(rawValue: HomeViewController.ReceivedNewsNotification), object: self)
            case "Blog": index = 0
                NotificationCenter.default.post(name: Notification.Name(rawValue: HomeViewController.ReceivedBlogNotification), object: self)
            case "Tree": index = 1
            case "Video": index = 2
            default: break
            }
            (window?.rootViewController as? UITabBarController)?.selectedIndex = index
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
}

