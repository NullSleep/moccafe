//
//  DetailViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 6/17/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SDWebImage
import AVFoundation
import AVKit


class DetailViewController: UIViewController {
    
    var article: Article?
    var searchText: String?
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle(NSLocalizedString("Play Video", comment: ""), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()

    @IBOutlet var articleDate: UILabel!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleText: UILabel!
    @IBOutlet var downloadVector: UIButton!
    @IBOutlet var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        articleDate.text = article?.created
        articleText.text = article?.content
        articleTitle.text = article?.title
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        } else {
            // Fallback on earlier versions
        }
        
      
        
        let video = URL.init(string: article?.videoUrl ?? "")

        if video != nil {
            downloadVector.isHidden = true
            self.view.addSubview(playButton)
            playButton.centerXAnchor.constraint(equalTo: articleImage.centerXAnchor).isActive = true
            playButton.centerYAnchor.constraint(equalTo: articleImage.centerYAnchor).isActive = true
            playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            playButton.addTarget(self, action: #selector(loadVideo), for: .touchUpInside)
        }
        
        if setImage(url: article?.picUrl ?? "", placeHolder: false, video: nil) {
        } else if setImage(url: article?.thumbUrl ?? "", placeHolder: true, video: video) {
        } else if video != nil {
            let image = UIImage(color: UIColor(red:0.09, green:0.10, blue:0.11, alpha:1.0), size: CGSize(width: 10, height: 10))
            self.articleImage.image = image
        }
        
        //var sizeOfContent = contentView.con
        
    }
    
    
    
    func setImage(url: String, placeHolder: Bool, video: URL?) -> Bool {
        var bool = false
        if let imageURL = URL.init(string: url) {
            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
                if image != nil {
                    bool = true
                }
            }
            articleImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
        } else if (placeHolder == true) && (articleImage.image == nil) && (video == nil) {
            self.downloadVector.isHidden = true
            self.articleImage.removeFromSuperview()
            let constraint = NSLayoutConstraint(item: self.articleDate, attribute: .bottom, relatedBy: .equal, toItem: self.articleTitle, attribute: .top, multiplier: 1, constant: -10)
            self.view.addConstraint(constraint)
        }
        return bool
    }

    @IBAction func downloadPic(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(articleImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: NSLocalizedString("Save error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("Saved!", comment: ""), message: NSLocalizedString("The image has been saved to your photos.", comment: ""), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default))
            present(ac, animated: true)
        }
    }
    
    func loadVideo() {
        
        if let videoURL = URL(string: article?.videoUrl ?? "") {
            let player = AVPlayer(url: videoURL)
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextvc = segue.destination as? HomeViewController {
            nextvc.searchText = self.searchText
        }
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        if let nextvc = parent as? HomeViewController {
            nextvc.searchText = self.searchText
        }
    }
}
