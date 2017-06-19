//
//  PostCell.swift
//  moccafe
//
//  Created by Carlos Arenas on 6/3/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postSubtitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        postImage.layer.cornerRadius = 10.0
    }

    func configureWithData(_ data: NSDictionary) {
        postDate.text = data["date"] as? String
        postTitle.text = data["title"] as? String
        postSubtitle.text = data["subtitle"] as? String
        //postImage.image = data["image"] as? UIImage //UIImage(named: postName.text!.replacingOccurrences(of: " ", with: "_"))
    }

    func changeStylToBlack() {
//        postImage?.layer.cornerRadius = 30.0
//        postTitle.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
//        postTitle.textColor = .white
//        backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
    }
}
