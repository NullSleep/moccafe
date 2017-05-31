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
    


//POST Profile
func postProfile(name: String, last_name: String, email: String, address: String, shipping: String, completionHandler: @escaping (JSON?, Error?) -> ()) {
    
    let url = "https://app.moccafeusa.com/api/v1/customers/update_profile"
    
    let profileAttributes = [String: Any]()
    
    
    let parameters = [ "name": name, "last_name": last_name, "email": email, "address": address, "shipping": shipping ]
    let params = ["customer": parameters]
 //   let json = JSON("customer", parameters)
    

    Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseString { response in
        print("Response String: \(response.result.value)")
        
       // let response = String(data: data, encoding: String.Encoding )
        print(response)
//        switch response.result {
//        case .success(let value):
//            print("value edit profile \(value)")
//            let json = JSON(rawValue: value)
//            completionHandler(json, nil)
//            
//        case .failure(let error): print("Error")
//        completionHandler(nil, error)
//            return
//        }
    }
}
}


//var hourly_pays_attributes = [[String: Any]]()
//var loads_attributes = [[String: Any]]()
//let payTypes = jsonToUpdateInterviewAPI.array?[5]["answer"].array ?? [JSON]()
//for item in (payTypes) {
//    if (item["pay"].string ?? "pay").lowercased().contains("hour") {
//        let hourlyPay = ["name" : "\(item["title"].string ?? "")", "rate" : "\(item["fee"].string ?? "name")" ]
//        hourly_pays_attributes.append(hourlyPay)
//    } else {
//        let loadType = ["title" : "\(item["title"].string ?? "")", "fee" : "\(item["fee"].string ?? "name")", "pay" : "\(item["pay"].string ?? "")"]
//        loads_attributes.append(loadType)
//    }
//}

//POST https://app.moccafeusa.com/api/v1/customers/update_profile
//{
//    "customer": {
//        "name": "Pepito",
//        "last_name": "Perez",
//        "email": "micorreo@moccafeusa.com",
//        "address": "Direccion uno",
//        "shipping": "Direccion dos - tal vez diferente a la direccion 1",
//        "phone": "00000 tel fijo",
//        "mobile": "315 00000",
//        "info": "Hola, soy Pepito y en este campo pongo informacion sobre mi mismo. Me gusta el cafe.",
//        "city": "New York",
//        "country_id": 1,
//        "user_status_id": 1,
//        "gender_id": 1
//    }
//}
