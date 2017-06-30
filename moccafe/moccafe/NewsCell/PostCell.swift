//
//  PostCell.swift
//  moccafe
//
//  Created by Carlos Arenas on 6/3/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SDWebImage


class PostCell: UITableViewCell {

    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postSubtitle: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet var containerView: UIView!
    
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
    }

    func configureWithData(_ data: NSDictionary) {
        index = data["index"] as? Int
        postDate.text = data["date"] as? String
        postTitle.text = data["title"] as? String
        postSubtitle.text = data["subtitle"] as? String
        
        let urlPic = "https://c2.staticflickr.com/8/7259/7520264210_0c98a6fab2_b.jpg"
            // (data["picUrl"] as? String) ?? ""
        let urlPlaceHolderImage = ""//"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjhfpaXnErAFp2f6vcCEVsQv7dKQa5NfWcvOKyYr0pdLS59ryL"
            //"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjhfpaXnErAFp2f6vcCEVsQv7dKQa5NfWcvOKyYr0pdLS59ryL"
            // data["thumbUrl"] as? String) ?? ""
        let videoURL = "c"
            //(data["videoUrl"] as? String) ?? ""
        
        let video = URL.init(string: videoURL)
        
        if video != nil {
            containerView.addSubview(playButton)
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
            self.postImage.isHidden = true
            let constraint = NSLayoutConstraint(item: self.postTitle, attribute: .bottom, relatedBy: .equal, toItem: self.postSubtitle, attribute: .top, multiplier: 1, constant: -10)
            self.containerView.addConstraint(constraint)
        }
        
        
        
        
        return bool
    }
    
    func loadVideo() {
        if delegate != nil {
            delegate?.playVideo(index: index!)
        }
    }
 
    func changeStylToBlack() {
//        postImage?.layer.cornerRadius = 30.0
//        postTitle.font = UIFont(name: "HelveticaNeue-Light", size:18) ?? .systemFont(ofSize: 18)
//        postTitle.textColor = .white
//        backgroundColor = UIColor(red: 250/255.0, green: 250/255.0, blue: 250/255.0, alpha: 1.0)
    }
}
