//
//  LunchViewController.swift
//  ShareMusic
//
//  Created by Mohammed on 8/7/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import YouTubePlayer


class LunchViewController: UIViewController {
    
    @IBOutlet var playBut: UIButton!
    @IBOutlet var playerView: YouTubePlayerView!
    var id: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "0",
            "showinfo": "0"
            ] as YouTubePlayerView.YouTubePlayerParameters
        
        playerView.loadVideoID(id)
        

       
        playerView.getCurrentTime()
        
    }
    

    @IBAction func play(_ sender: Any) {
        
        if playerView.ready {
             if playerView.playerState != YouTubePlayerState.Playing {
                 playerView.play()
                 playBut.setTitle("Pause", for: .normal)
             } else {
                 playerView.pause()
                 playBut.setTitle("Play", for: .normal)
             }
         }
    }
    
}

//extension LunchViewController: YouTubePlayerDelegate {
//
//
//
//}
