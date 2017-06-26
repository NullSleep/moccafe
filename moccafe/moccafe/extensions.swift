//
//  extensions.swift
//  moccafe
//
//  Created by Valentina Henao on 5/30/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func imageWithColor(color: UIColor) -> UIImage? {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

protocol switchHomeOptionDelegate {
    func loadBlog()
    func loadNews()
}

@objc protocol performNavigationDelegate {
    var searchController: UISearchController {
        get
    }
    @objc optional var searchText: String? { get }
    
    @objc optional func startWithSearch()
    @objc optional func loadDetail(article: Article)
    @objc optional func loadQuestions()
    @objc optional func loadVideo()
    @objc optional func cancelSearch()
    @objc optional func updateSearch()


}

extension Dictionary where Value: Equatable {

    func keysForValue(value: Value) -> [Key] {
        return flatMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}
