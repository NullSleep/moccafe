//
//  APICall.swift
//  moccafe
//
//  Created by Valentina Henao on 5/23/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APICall: NSObject {
    
    //MARK: Authentication
    
    func signup(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/customers/signup"
        let params = ["customer": json.dictionaryObject ?? ["":""]]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON {
            response in
            switch response.result {
                
                case .success(let value):
                let json = JSON(rawValue: value)
                print("signup response \(json)")
                completionHandler(json, nil)
                case .failure(let error):
                completionHandler(nil, error)
                
            }
        }
    }
    
    func login(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/customers/login"
        let params = ["customer": json.dictionaryObject ?? ["":""]]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
                
                case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                case .failure(let error):
                completionHandler(nil, error)
                
            }
        }
    }
    
    //MARK: View and Edit Profile
    
    func getProfile(completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let token = (UserDefaults.standard.value(forKey: "token") as? String) ?? ""
        
        let url = "https://app.moccafeusa.com/api/v1/customers/profile"
        let headers = ["Authorization": token]
        let language = Locale.preferredLanguages[0]
        
        Alamofire.request(url, method: .get, parameters: ["language": language], encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
            case .failure(let error):
            completionHandler(nil, error)
                return
            }
        }
    }

    func postProfile(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let token = (UserDefaults.standard.value(forKey: "token") as? String) ?? ""
        let url = "https://app.moccafeusa.com/api/v1/customers/update_profile"

        let params = ["customer": json.dictionaryObject ?? ["":""]]
       // json["language"] = Locale.preferredLanguages[0]

        
        let headers = ["Authorization": token]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
            
//            print("params edit profile \(params)")
//            print("url edit profile \(url)")
//            print("headers edit profile \(headers)")
            
            switch response.result {
            case .success(let value):
            let json = JSON(rawValue: value)
            print("response edit profile \(json)")
            completionHandler(json, nil)
            case .failure(let error):
            completionHandler(nil, error)
                
            }
        }
    }

    //MARK: Submit Questions and question type options

    func getList(url: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        let language = Locale.preferredLanguages[0]
        
        Alamofire.request(url, method: .get, parameters: ["language": language], encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
            case .failure(let error):
            completionHandler(nil, error)
                return
            }
        }
    }

    func postQuestion(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/questions/post_question"
        var params = json.dictionaryObject
        params?["language"] = Locale.preferredLanguages[0]

        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
            case .failure(let error):
            completionHandler(nil, error)
                return
            }
        }
    }

    //MARK: Retrieve Blog details and articles
    
    func getBlogDetails(completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/blogs/details"
        let language = Locale.preferredLanguages[0]

        
        Alamofire.request(url, method: .get, parameters: ["language": language], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
                
                case .success(let value):
                    let json = JSON(rawValue: value)
                    completionHandler(json, nil)
                
                
                case .failure(let error):
                    completionHandler(nil, error)
                    return
            }
        }
    }
    
    func retrieveArticles(url: String, json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = url
        var params = json.dictionaryObject
        params?["language"] = Locale.preferredLanguages[0]

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
            case .failure(let error): 
                completionHandler(nil, error)
                return
            }
        }
    }
    
    func getArticleUrl(completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/settings/shop_url"
        let language = Locale.preferredLanguages[0].localized
        
        
        Alamofire.request(url, method: .get, parameters: ["language": language], encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
                
            case .failure(let error):
                completionHandler(nil, error)
                return
            }
        }
    }
    
    func storeToken(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/customers/store_token"
        var params = json.dictionaryObject
        params?["language"] = Locale.preferredLanguages[0]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
                
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
            case .failure(let error):
                completionHandler(nil, error)
                return
            }
        }
    }

}

extension String {
    
    var localized: String {
        if self.prefix(2) == "ja" {
            return "jp"
        } else if self.prefix(2) == "en" {
            return "en"
        }
        return "en"
    }
   
}

