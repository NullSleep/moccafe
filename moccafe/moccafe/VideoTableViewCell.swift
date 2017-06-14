//
//  VideoTableViewCell.swift
//  moccafe
//
//  Created by Valentina Henao on 6/5/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet var videoDate: UILabel!
    @IBOutlet var videoTitle: UILabel!
    @IBOutlet var videoThumbnail: UIImageView!
    @IBOutlet var videoSubtitle: UILabel!
    
    var delegate: performNavigationDelegate?

    @IBOutlet var containingView: UIView!
    @IBOutlet var questionButton: UIButton!
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Play Video", for: .normal)
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
        //        thumbnail.image = UIImage(named: postName.text!.replacingOccurrences(of: " ", with: "_"))
    }
}
