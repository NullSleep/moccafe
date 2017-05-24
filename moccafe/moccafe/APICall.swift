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
    
    //GET Blog ID
    func getID(email: String, password: String, firstName: String, lastName: String, checkBox: Bool, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https:// /blogs/news_blog_id"
        let parameters = ["email": email, "first_name": firstName, "last_name": lastName, "newsletter":"\(checkBox)", "password": password, "password_confirmation": password]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            print(response)
            switch response.result {
            case .success(let value):
                print("value get blog id \(value)")
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
            case .failure(let error): print("Error")
            completionHandler(nil, error)
                return
            }
        }
}
    //GET Blog
    func getBlog(id: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
        
        let url = "https:// /blogs/#{blog_id}"
        let parameters = ["id": id]
        
        Alamofire.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON{ response in
            print(response)
            switch response.result {
            case .success(let value):
                print("value get blog \(value)")
                let json = JSON(rawValue: value)
                completionHandler(json, nil)
                
            case .failure(let error): print("Error")
            completionHandler(nil, error)
                return
            }
        }
    }
    
}


//{
//    "blog": {
//        "id": 12531,
//        "title": "My Blog",
//        "commentable": "yes",
//        "likeable": "yes",
//        "tags": "Coffee, Colombia"
//        "updated_at": "2017-01-05T15:36:16-05:00",
//        "created_at": "2017-01-05T15:36:16-05:00",
//    }
//}
