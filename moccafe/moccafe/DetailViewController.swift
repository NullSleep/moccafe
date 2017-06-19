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

    @IBOutlet var articleDate: UILabel!
    @IBOutlet var articleImage: UIImageView!
    @IBOutlet var articleTitle: UILabel!
    @IBOutlet var articleText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        articleDate.text = article?.created
        
        let imageStringURL = article?.picUrl ?? ""//"https://c2.staticflickr.com/8/7259/7520264210_0c98a6fab2_b.jpg"
        if let imageURL = URL.init(string: imageStringURL) {
            let myBlock: SDExternalCompletionBlock! = { (image, error, cacheType, imageURL) -> Void in
            }
        
        articleImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "no_image-128"), options: SDWebImageOptions.progressiveDownload, completed: myBlock)
        }
    }

    @IBAction func downloadPic(_ sender: UIButton) {
        UIImageWriteToSavedPhotosAlbum(articleImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
