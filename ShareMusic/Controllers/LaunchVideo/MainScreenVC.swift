//
//  MainScreenVC.swift
//  ShareMusic
//
//  Created by Mohammed on 7/27/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import SDWebImage
import WebKit
import YoutubeKit


class MainScreenVC: UIViewController {
    
    private var player: YTSwiftyPlayer!

    @IBOutlet var videoWebView: WKWebView!
    @IBOutlet var videoTitle: UILabel!
    
    var items = [Video]()
    
    var videos:[Video] = []
    
    @IBOutlet weak var tableView :UITableView!

        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Create a new player
            player = YTSwiftyPlayer(
                frame: CGRect(x: 0, y: 0, width: 640, height: 480),
                playerVars: [
                    .playsInline(true),
                    .videoID("_6u6UrtXUEI"),
                    .loopVideo(true),
                    .showRelatedVideo(true)
                ])
            
            // Enable auto playback when video is loaded
            player.autoplay = true
            
            // Set player view
            view = player

            // Set delegate for detect callback information from the player
            player.delegate = self
            
            // Load video player
            player.loadPlayer()
            
            
            
            
            
            
//            let video1 = Video()
//            video1.key = "Z3megGZrFMI"
//            video1.title = "Helloooooo"
//            videos.append(video1)
//            initTableView()


        }
}


extension MainScreenVC: UITableViewDelegate, UITableViewDataSource, YTSwiftyPlayerDelegate {
    
            func initTableView(){
                print(videos.count)
              tableView.dataSource = self
              tableView.delegate = self

            }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemYoutubeCell", for: indexPath) as! ItemYoutubeCVC
//        
//        cell.videoTitle.text = videos[indexPath.row].key
//        
//        let url = URL(string: "https://img.youtube.com/vi/\(videos[indexPath.row].key)/default.jpg")
//        cell.videoImage.downloadedFrom(url: url!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          
       let urlVideo = "https://www.youtube.com/embed/\(videos[indexPath.row].key)"
       self.videoWebView.load(NSURLRequest(url: NSURL(string: urlVideo)! as URL) as URLRequest)
       self.videoTitle.text = videos[indexPath.row].title
    }
    
    
    
    func playerReady(_ player: YTSwiftyPlayer) {
        print(#function)
        // After loading a video, player's API is available.
        // e.g. player.mute()
    }
    
    func player(_ player: YTSwiftyPlayer, didUpdateCurrentTime currentTime: Double) {
        print("\(#function): \(currentTime)")
    }
    
    func player(_ player: YTSwiftyPlayer, didChangeState state: YTSwiftyPlayerState) {
        print("\(#function): \(state)")
    }
    
    func player(_ player: YTSwiftyPlayer, didChangePlaybackRate playbackRate: Double) {
        print("\(#function): \(playbackRate)")
    }
    
    func player(_ player: YTSwiftyPlayer, didReceiveError error: YTSwiftyPlayerError) {
        print("\(#function): \(error)")
    }
    
    func player(_ player: YTSwiftyPlayer, didChangeQuality quality: YTSwiftyVideoQuality) {
        print("\(#function): \(quality)")
    }
    
    func apiDidChange(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    func youtubeIframeAPIReady(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    func youtubeIframeAPIFailedToLoad(_ player: YTSwiftyPlayer) {
        print(#function)
    }
    
    
}
