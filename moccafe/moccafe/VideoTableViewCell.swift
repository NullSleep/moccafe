//
//  VideoTableViewCell.swift
//  moccafe
//
//  Created by Valentina Henao on 6/5/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    
    var delegate: performNavigationDelegate?

    @IBOutlet var videoThumbnail: UIImageView!

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
    //    questionButton.layer.borderColor = UIColor.white.cgColor//UIColor(red:0.36, green:0.57, blue:0.02, alpha:1.0).cgColor
//        questionButton.layer.cornerRadius = 12.5
//        questionButton.layer.borderWidth = 1
//        questionButton.addTarget(self, action: #selector(loadQuestionView), for: .touchUpInside)
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
    
}
