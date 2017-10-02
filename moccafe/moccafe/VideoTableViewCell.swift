//
//  VideoTableViewCell.swift
//  moccafe
//
//  Created by Valentina Henao on 6/5/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SDWebImage


class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet var videoDate: UILabel!
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var videoThumbnail: UIImageView!
    @IBOutlet var videoSubtitle: UILabel!
    
    @IBOutlet var likeButton: UIButton!
    
    var delegate: performNavigationDelegate?

    @IBOutlet var containingView: UIView!
    @IBOutlet var questionButton: UIButton!
    
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
        containingView.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: videoThumbnail.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: videoThumbnail.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.addTarget(self, action: #selector(loadVideo), for: .touchUpInside)
        
        likeButton.setImage(UIImage(named: "thumb"), for: .normal)
        likeButton.setImage(UIImage(named: "thumbfilled"), for: .selected)
        
        containingView.layer.borderColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0).cgColor
        containingView.layer.borderWidth = 1

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        
        
    }
    
    func loadQuestionView() {
        
        if delegate != nil {
            delegate!.loadQuestions!()
        }
    }
   
    func loadVideo() {
        if delegate != nil {
            delegate?.loadVideo!()
        }
    }
    
    func configureWithData(_ data: NSDictionary) {
        videoDate.text = data["date"] as? String
        videoTitle.text = data["title"] as? String
        videoSubtitle.text = data["subtitle"] as? String
        likeButton.isSelected = data["liked"] as! Bool

        contentView.backgroundColor = UIColor(red: 0.91, green: 0.92, blue: 0.92, alpha: 1.0)
        
        let urlPic = (data["picUrl"] as? String) ?? ""
        let urlPlaceHolderImage = (data["thumbUrl"] as? String) ?? ""
        let videoURL = (data["videoUrl"] as? String) ?? ""
        
        let video = URL.init(string: videoURL)

        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        if setImage(url: urlPic) {
        } else if setImage(url: urlPlaceHolderImage) {
        } else if video != nil {
            let image = UIImage(color: UIColor(red:0.09, green:0.10, blue:0.11, alpha:1.0), size: CGSize(width: 10, height: 10))
            self.videoThumbnail.image = image
        }
        
        
        //        thumbnail.image = UIImage(named: postName.text!.replacingOccurrences(of: " ", with: "_"))
    }
    
    func setImage(url: String) -> Bool {
        var bool = false
        if let imageURL = URL.init(string: url) {
            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
                if image != nil {
                    bool = true
                }
            }
            videoThumbnail.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
        }
        return bool
    }
}
