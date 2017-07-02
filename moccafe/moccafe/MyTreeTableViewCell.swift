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
    
    @IBOutlet var likeButton: UIButton!
    
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
        likeButton.setImage(UIImage(named: "thumb"), for: .normal)
        likeButton.setImage(UIImage(named: "thumbfilled"), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureWithData(_ data: NSDictionary) {
        index = data["index"] as? Int
        date.text = data["date"] as? String
        title.text = data["title"] as? String
        subtitle.text = data["subtitle"] as? String
        likeButton.isSelected = data["liked"] as! Bool

        
        let urlPic = (data["picUrl"] as? String) ?? ""

        let urlPlaceHolderImage = (data["thumbUrl"] as? String) ?? ""
        let videoURL = (data["videoUrl"] as? String) ?? ""
        
        let video = URL.init(string: videoURL)
        
        if video != nil {
            contentView.addSubview(playButton)
            playButton.centerXAnchor.constraint(equalTo: postImage.centerXAnchor).isActive = true
            playButton.centerYAnchor.constraint(equalTo: postImage.centerYAnchor).isActive = true
            playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            playButton.addTarget(self, action: #selector(loadVideo), for: .touchUpInside)
        }
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
            if setImage(url: urlPic, placeHolder: false, video: nil) {
            } else if setImage(url: urlPlaceHolderImage, placeHolder: true, video: video) {
            } else if video != nil {
                let image = UIImage(color: UIColor(red:0.09, green:0.10, blue:0.11, alpha:1.0), size: CGSize(width: 10, height: 10))
                self.postImage.image = image
            }        
    }
    
    func setImage(url: String, placeHolder: Bool, video: URL?) -> Bool {
        var bool = false
        if let imageURL = URL.init(string: url) {
            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
                if image != nil {
                    bool = true
                }
            }
            postImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
        } else if (placeHolder == true) && (postImage.image == nil) && (video == nil) {
                self.postImage.removeFromSuperview()
                let constraint = NSLayoutConstraint(item: self.title, attribute: .bottom, relatedBy: .equal, toItem: self.subtitle, attribute: .top, multiplier: 1, constant: -10)
                self.contentView.addConstraint(constraint)
            }

        
        
        
        return bool
    }
    
    func loadVideo() {
        if delegate != nil {
            delegate?.playVideo(index: index!)
        }
    }
    
    
    
}
