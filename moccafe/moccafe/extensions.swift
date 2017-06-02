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
