//
//  VIdeosTableViewController.swift
//  moccafe
//
//  Created by Valentina Henao on 6/5/17.
//  Copyright © 2017 moccafe. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation


class VideosTableViewController: UITableViewController, performNavigationDelegate {

    @IBOutlet var questionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            questionButton.layer.borderColor = UIColor.white.cgColor//UIColor(red:0.36, green:0.57, blue:0.02, alpha:1.0).cgColor
                questionButton.layer.cornerRadius = 12.5
                questionButton.layer.borderWidth = 1
                questionButton.addTarget(self, action: #selector(loadQuestions), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath) as? VideoTableViewCell
        cell?.delegate = self

        return cell!
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loadVideo()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextvc = segue.destination as? ContactUsViewController {
            nextvc.calledFrom = "https://app.moccafeusa.com/api/v1/questions/video_options"
        }
    }
    
    func loadQuestions() {
        performSegue(withIdentifier: "showQuestions", sender: self)
    }
    
    func loadVideo() {

        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

}
