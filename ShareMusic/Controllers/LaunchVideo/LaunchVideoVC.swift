//
//  MainVC.swift
//  ShareMusic
//
//  Created by Mohammed on 8/4/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import UIKit
import SDWebImage
import WebKit
import YoutubeKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import Alamofire
import FacebookLikeReaction

class LaunchVideoVC: UIViewController {
    
    private var player: YTSwiftyPlayer!
    @IBOutlet weak var tableView :UITableView!
    @IBOutlet var cancleParty: UIBarButtonItem!
    @IBOutlet var videoView: WKWebView!
    
    var videdId: String!
    var status: String!
    var keyHostUser: String!
    var partyStrat: Bool?
    var keyCurrentUser: String!
    
    var videos:[Video] = []
    let defaults = UserDefaults.standard
    var refernceFireBase = Database.database().reference()
    
    
        @IBOutlet var buttonReaction: UIButton!
         var reactionView: ReactionView?
        @IBOutlet var viewForReaction: UIView!
    //    var items = [Video]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        
        if videdId != nil{
            
            playerViedo(videdId: videdId)
  
            if partyStrat ?? false {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                listenToEndParty()
                self.tableView.tableFooterView?.isHidden = false
                buttonsReaction()
                //                playOrPuse()
                return
            }else{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                player?.autoplay = true
                //                listenToReaction()
                self.tableView.tableFooterView?.isHidden = true
                getRelatedVideo(idVideo: videdId)
                
            }
        } else{
            print("fuck")
        }
    }
    
    func playerViedo(videdId: String){
        // Create a new player
        player = YTSwiftyPlayer(
            frame: CGRect(x: 0, y: 0, width: videoView.frame.size.width, height: videoView.frame.size.height),
            playerVars: [
                .playsInline(true),
                .videoID(videdId),
                .showRelatedVideo(true),
                .showFullScreenButton(false),
                .showControls(.showAfterPlaying)
                
        ])
        
        // Set player view
        self.videoView.addSubview(player ?? YTSwiftyPlayer())
        
        // Set delegate for detect callback information from the player
        player.delegate = self
        
        // Load video player
        player.loadPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func endParty(_ sender: Any) {
        
        let reference = Database.database().reference().child("User").queryOrdered(byChild: "email")
        let emailUser = Auth.auth().currentUser?.email
        reference.queryEqual(toValue: emailUser).observe(.value) { (dataSnapshot) in
            
            for user in dataSnapshot.children{
                let userChild = user as! DataSnapshot
                let key = userChild.key
                
                let reference = Database.database().reference().child("Party").child(key).removeValue()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                self.present(vc!, animated: true, completion: nil)
                
            }
        }
    }
    
        func buttonsReaction() {
    
            viewForReaction.addSubview(buttonReaction)
    
            
            reactionView = ReactionView()
    
            let reactions: [Reaction] = [Reaction(title: "Laugh", imageName: "icn_laugh"),
                                        Reaction(title: "Like", imageName: "icn_like"),
                                        Reaction(title: "Angry", imageName: "icn_angry"),
                                        Reaction(title: "Love", imageName: "icn_love"),
                                        Reaction(title: "Sad", imageName: "icn_sad")]
    
            reactionView?.initialize(delegate: self , reactionsArray: reactions, sourceView: self.view, gestureView: buttonReaction)
        }
    
    
    
    func listenToEndParty(){
        
        let reference = Database.database().reference().child("Party").queryOrdered(byChild: "keyHosted")
        reference.queryEqual(toValue: keyCurrentUser).observe(.value) { (dataSnapshot) in
            if !dataSnapshot.exists() {
                print("Child is removed")
                self.player.stopVideo()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                self.present(vc!, animated: true, completion: nil)
            }else{
                self.playOrPuse()
                print("Your friend is already in the party")
            }
        }
    }
    
    
    func playOrPuse(){
        let reference = Database.database().reference().child("Party").queryOrdered(byChild: "keyHosted")
        reference.queryEqual(toValue: keyCurrentUser).observe(.value) { (dataSnapshot) in
            
            for child in dataSnapshot.children{
                let partyChild = child as! DataSnapshot
                let statusValue = partyChild.value as! [String: Any]
                let status = statusValue["Status"] as! String
                print("The status is: \(status)")
                if status.elementsEqual("playing") {
                    print("player is playing")
                    self.player.playVideo()
                    self.player?.autoplay = true
                    return
                }else{
                    self.player.pauseVideo()
                    
                    self.player.loadPlayer()
                    return
                }
            }
        }
    }
    
    func listenToReaction(){
        let reference = Database.database().reference().child("Party").queryOrdered(byChild: "keyMangerUser")
        reference.queryEqual(toValue: keyCurrentUser).observe(.value) { (dataSnapshot) in
            
            for child in dataSnapshot.children{
                let partyChild = child as! DataSnapshot
                let statusValue = partyChild.value as! [String: Any]
                let reaction = statusValue["reaction"] as? String
                print("The status is: \(reaction)")
                
                if reaction?.elementsEqual("Love") ?? false {
                    print("Love")
                    
                    return
                }else if reaction?.elementsEqual("Like") ?? false{
                    print("Like")
                    
                    return
                }else if reaction?.elementsEqual("Angry") ?? false{
                    print("Angry")
                    
                    return
                }else if reaction?.elementsEqual("Sad") ?? false{
                    print("Sad")
                    
                    return
                }else{
                    print("Laugh")
                }
            }
        }
    }
    
    func getRelatedVideo(idVideo: String){
        
        let request = "https://www.googleapis.com/youtube/v3/search?part=snippet&relatedToVideoId=\(idVideo)&type=video&key=AIzaSyDPCv2BIZ9OXdXj0avV72QB3esEmzp9Vh0"
        //        AIzaSyAb6bz7DDzn_XVVGO2_M130Hu8096dZTe8
        //        AIzaSyDPCv2BIZ9OXdXj0avV72QB3esEmzp9Vh0
        
        print(request)
        
        AF.request(request).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                print("Helloooooooooooooooooooooooooooooo")
                
                let jsonObject = json as! [String:Any]
                let kind = jsonObject["kind"] as? String
                
                if kind != nil {
                    let items = jsonObject["items"] as! NSArray
                    let allitems = try! JSONSerialization.data(withJSONObject: items, options: [])
                    let decoder = JSONDecoder()
                    
                    self.videos.append(contentsOf: try! decoder.decode([Video].self, from: allitems))
                    self.tableView.reloadData()
                    self.initTableView()
                    
                }else{
                    let errorMessage = jsonObject["error"] as! Any
                    let message = errorMessage
                    print(message)
                }
                
                break
            case .failure(let error):
                print("Error is: \(error.localizedDescription)")
            }
        }
    }
    
    
    func addReactionInRealTimeDataBase(reactionTitle: String){
        let keyCurrentUser = UserDefaults.standard.string(forKey: "key")
        
        let reference = Database.database().reference().child("Party").queryOrdered(byChild: "keyHosted")
        reference.queryEqual(toValue: keyCurrentUser).observe(.value) { (dataSnapshot) in
            
            for user in dataSnapshot.children{
                
                let userChild = user as! DataSnapshot
                let key = userChild.key
                print(userChild.key)
                Database.database().reference().child("Party").child(key).child("reaction").setValue(reactionTitle)
            }
        }
    }
    
    func sendRequest(videdId: String) {
        
        let keyMangerUser = defaults.string(forKey: "key")
        
        var requestObj = [String: Any]()
        requestObj["keyMangerUser"] = keyMangerUser
        requestObj["keyHosted"] = keyHostUser
        requestObj["videdId"] = videdId
        requestObj["Status"] = "playing"
        
        refernceFireBase.child("Party").child(keyMangerUser ?? "").setValue(requestObj)
    }
    
    
}




extension LaunchVideoVC: UITableViewDelegate, UITableViewDataSource, YTSwiftyPlayerDelegate, FacebookLikeReactionDelegate {
    
    func initTableView(){
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("The Count is\(videos.count)")
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemsLaunchVideoCVC", for: indexPath) as! ItemsLaunchVideoCVC
        
        cell.titleVideo.text = videos[indexPath.row].snippet?.title
        let url = URL(string: videos[indexPath.row].snippet?.thumbnails?.high?.url ?? "")
        cell.imageVideo.downloadedFrom(url: url!)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.sendRequest(videdId: (videos[indexPath.row].id?.videoID)!)
        player.stopVideo()
        player.clearVideo()
        playerViedo(videdId: (videos[indexPath.row].id?.videoID)!)
        player?.autoplay = true
              
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
        let keyCurrentUser = UserDefaults.standard.string(forKey: "key")
        let reference = Database.database().reference().child("Party")
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(keyCurrentUser!){
                print("true rooms exist")
                let ref = reference.child(keyCurrentUser!).child("Status")
                
                switch state.rawValue {
                case 1:
                    let Status = "playing"
                    ref.setValue(Status)
                    break
                case 2:
                    let Status = "paused"
                    ref.setValue(Status)
                    break
                default:
                    ref.setValue("paused")
                }
                
            }else{
                print("false room doesn't exist")
            }
        })
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
    
    
    
    
    func selectedReaction(reaction: Reaction) {
        self.addReactionInRealTimeDataBase(reactionTitle: reaction.title!)
        print("Selected-------\(reaction.title)")
        
    }
    
    
    
}
