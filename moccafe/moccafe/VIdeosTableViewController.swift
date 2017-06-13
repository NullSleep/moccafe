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
    
    
    @IBAction func profileAction(_ sender: UIBarButtonItem) {
        loadProfile()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            questionButton.layer.borderColor = UIColor.white.cgColor
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

 

    
    func loadVideo() {

        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func loadQuestions() {
        
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "contactUs") as! ContactUsViewController
        
        vc.calledFrom = "https://app.moccafeusa.com/api/v1/questions/video_options"
        self.navigationController?.pushViewController(vc, animated:true)
        
        
    }
    
    func loadProfile() {
        let vc = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "ProfileScreen") as! ProfileTableViewController
        

        self.navigationController?.pushViewController(vc, animated:true)
    }

}
