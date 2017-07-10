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
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString { response in
            print("data signup \(params)")
            switch response.result {
            case .success(let value): print("value signup \(value)")
            let json = JSON(rawValue: value)
            completionHandler(json, nil)
            case .failure(let error): print("ERROR signup")
            completionHandler(nil, error)
                
            }
        }
    }
    
    func login(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/customers/login"
        let params = ["customer": json.dictionaryObject ?? ["":""]]
        
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(let value): print("value \(value)")
            let json = JSON(rawValue: value)
            completionHandler(json, nil)
            case .failure(let error): print("ERROR")
            completionHandler(nil, error)
                
            }
        }
    }
    
    //MARK: View and Edit Profile
    
    func getProfile(completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/customers/profile"
        let headers = ["Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJtb2NjYWZldXNhLmNvbSIsInVzZXJfaWQiOjcsIm5hbWUiOiJwZXBpdG8ifQ.Q3XO7UFvN2wKn7YbUxUFjAeZie2xqYnsqSe47DzeMVk"]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                print("get profile result \(value)")
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
            case .failure(let error): print("Error")
            completionHandler(nil, error)
                return
            }
        }
    }

    func postProfile(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/customers/update_profile"
        let params = ["customer": json.dictionaryObject ?? ["":""]]
        
        let headers = ["Authorization": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJtb2NjYWZldXNhLmNvbSIsInVzZXJfaWQiOjcsIm5hbWUiOiJwZXBpdG8ifQ.Q3XO7UFvN2wKn7YbUxUFjAeZie2xqYnsqSe47DzeMVk"]

        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseString { response in
            
            switch response.result {
            case .success(let value): print("value \(value)")
            let json = JSON(rawValue: value)
            completionHandler(json, nil)
            case .failure(let error): print("ERROR")
            completionHandler(nil, error)
                
            }
        }
    }

    //MARK: Submit Questions and question type options

    func getList(url: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
            case .failure(let error): print("Error")
            completionHandler(nil, error)
                return
            }
        }
    }

    func postQuestion(json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/questions/post_question"
        let params = json.dictionaryObject
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            switch response.result {
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
            case .failure(let error): print("Error")
            completionHandler(nil, error)
                return
            }
        }
    }

    //MARK: Retrieve Blog details and articles
    
    func getBlogDetails(completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https://app.moccafeusa.com/api/v1/blogs/details"
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let value):
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
            case .failure(let error): print("Error")
                completionHandler(nil, error)
                return
            }
        }
    }
    
    func retrieveArticles(url: String, json: JSON, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
    let url = url 
    let params = json.dictionaryObject

        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            print(response)
            switch response.result {
            case .success(let value):
                print("response retrieving articles \(value)")
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
            case .failure(let error): print("Error")
                completionHandler(nil, error)
                return
            }
        }
    }

}

