//
//  BackAlert.swift
//  moccafe
//
//  Created by Valentina Henao on 10/14/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import Foundation
import UIKit

class BackAlert: UIView {
    
    var delegate: BackAlertDelegate?
    
    @IBAction func login(_ sender: UIButton) {
        delegate?.login()
    }
    
}


