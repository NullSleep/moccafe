//
//  MyTreeTableViewCell.swift
//  moccafe
//
//  Created by Valentina Henao on 6/14/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SDWebImage


class MyTreeTableViewCell: UITableViewCell {

    @IBOutlet var date: UILabel!
    @IBOutlet var title: UILabel!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var subtitle: UILabel!
    
    var delegate: postCellTableViewDelegate?
    var index: Int?
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle(NSLocalizedString("Play Video", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWithData(_ data: NSDictionary) {
        index = data["index"] as? Int
        date.text = data["date"] as? String
        title.text = data["title"] as? String
        subtitle.text = data["subtitle"] as? String
        //        thumbnail.image = UIImage(named: postName.text!.replacingOccurrences(of: " ", with: "_"))
        let urlPic = "https://c2.staticflickr.com/8/7259/7520264210_0c98a6fab2_b.jpg"// (data["picUrl"] as? String) ?? ""
        let urlPlaceHolderImage = ""//"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjhfpaXnErAFp2f6vcCEVsQv7dKQa5NfWcvOKyYr0pdLS59ryL"// data["thumbUrl"] as? String) ?? ""
        let videoURL = ""//(data["videoUrl"] as? String) ?? ""
        
        let video = URL.init(string: videoURL)
        
        if video != nil {
            contentView.addSubview(playButton)
            playButton.centerXAnchor.constraint(equalTo: postImage.centerXAnchor).isActive = true
            playButton.centerYAnchor.constraint(equalTo: postImage.centerYAnchor).isActive = true
            playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            playButton.addTarget(self, action: #selector(loadVideo), for: .touchUpInside)
        }
        
        if setImage(url: urlPic) {
            
        } else if setImage(url: urlPlaceHolderImage) {
            
        } else if video != nil {
            let image = UIImage(color: UIColor(red:0.09, green:0.10, blue:0.11, alpha:1.0), size: CGSize(width: 10, height: 10))
            postImage.image = image
        }
        
    }
    
    func setImage(url: String) -> Bool {
        var bool = false
        if let imageURL = URL.init(string: url) {
            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
                if image != nil {
                    bool = true
                }
            }
            postImage.sd_setImage(with: imageURL, placeholderImage: nil, options: SDWebImageOptions.progressiveDownload, completed: myBlock)
        }
        
        return bool
    }
    
    func loadVideo() {
        if delegate != nil {
            delegate?.playVideo(index: index!)
        }
    }
    
    
    
}
