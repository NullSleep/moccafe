//
//  MyTreeTableViewCell.swift
//  moccafe
//
//  Created by Valentina Henao on 6/14/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class MyTreeTableViewCell: UITableViewCell {

    @IBOutlet var date: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var thumbnail: UIImageView!
    @IBOutlet var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithData(_ data: NSDictionary) {
        date.text = data["date"] as? String
        title.text = data["title"] as? String
        subtitle.text = data["subtitle"] as? String
        //        thumbnail.image = UIImage(named: postName.text!.replacingOccurrences(of: " ", with: "_"))
    }

}
