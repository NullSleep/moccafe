//
//  DetailViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 6/17/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var article: Article?
    var searchText: String?

    @IBOutlet var articleDate: UILabel!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleText: UILabel!
    @IBOutlet var downloadVector: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white

        articleDate.text = article?.created
        let video = URL.init(string: article?.videoUrl ?? "")

        
        if setImage(url: article?.picUrl ?? "", placeHolder: false, video: nil) {
        } else if setImage(url: article?.thumbUrl ?? "", placeHolder: true, video: video) {
        } else if video != nil {
            let image = UIImage(color: UIColor(red:0.09, green:0.10, blue:0.11, alpha:1.0), size: CGSize(width: 10, height: 10))
            self.articleImage.image = image
        }
        
//        let imageStringURL = article?.picUrl ?? ""
//        if let imageURL = URL.init(string: imageStringURL) {
//            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
//            }
//        
//        articleImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
//        }
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
            self.articleImage.isHidden = true
            let constraint = NSLayoutConstraint(item: self.articleTitle, attribute: .bottom, relatedBy: .equal, toItem: self.articleDate, attribute: .top, multiplier: 1, constant: -10)
            self.articleTitle.addConstraint(constraint)
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
