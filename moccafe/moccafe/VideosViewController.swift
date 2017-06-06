//
//  VideosViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 5/22/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideosViewController: UIViewController {

    var moviePlayer: AVPlayer?
    
    var videoView: UIView!
    
    var stopButton: UIButton?
    
    let activityIndicator: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Play Video", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        return button
    }()
    
    
    func handlePlay() {
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        moviePlayer = AVPlayer(url: videoURL!)
        let playerLayer = AVPlayerLayer(player: moviePlayer)
        playerLayer.frame = self.videoView.bounds
        self.videoView.layer.addSublayer(playerLayer)
        moviePlayer?.play()
        activityIndicator.startAnimating()
        playButton.isHidden = true
    }
    
    func handleStop() {
        moviePlayer?.pause()
        playButton.isHidden = false
        videoView.bringSubview(toFront: playButton)

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoView = UIView(frame: CGRect(x: 0, y: 150, width: self.view.frame.width, height: 250))
        videoView.backgroundColor = UIColor.black
        self.view.addSubview(videoView)
        videoView.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        videoView.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: videoView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: videoView.centerYAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        stopButton = UIButton(frame: CGRect(x: 0, y: videoView.frame.height-30, width: 130, height: 30))
        stopButton?.setTitle("Stop Video", for: .normal)
       
        stopButton?.addTarget(self, action: #selector(handleStop), for: .touchUpInside)
        videoView.addSubview(stopButton!)

    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
