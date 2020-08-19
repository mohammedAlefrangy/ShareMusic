//
//  FriendsVC.swift
//  ShareMusic
//
//  Created by Mohammed on 7/27/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
//import SDWebImage
//import WebKit
//import Alamofire


class FriendsVC: UIViewController {

    var FriendData :[Home] = []
    
    @IBOutlet weak var tableViewFriends: UITableView!
    
       override func viewDidLoad() {
              super.viewDidLoad()
          initTableView()
    }
}


extension FriendsVC: UITableViewDelegate, UITableViewDataSource{

    func initTableView(){
        tableViewFriends.dataSource = self
        tableViewFriends.delegate = self
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return items.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFriends.dequeueReusableCell(withIdentifier: "FriendsCVC", for: indexPath) as! FriendsCVC
        
//        cell.titleVideo.text = items[indexPath.row].snippet?.title
//        let url = URL(string: items[indexPath.row].snippet?.thumbnails?.thumbnailsDefault?.url ?? "")
//        cell.imageVideo.downloadedFrom(url: url!)
//        cell.imageUser.downloadedFrom(url: url!)
//        cell.discriptionVideo.text = items[indexPath.row].snippet?.snippetDescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//         let mainstoryboard = UIStoryboard(name: "Main", bundle: nil)
//
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC") as! MainVC
//        vc.id = self.items[indexPath.row].id?.videoID
//      self.navigationController?.pushViewController(vc, animated: true)
//            self.showProfileView(user:user!)
    }
    
    
}







//    override func viewWillAppear(_ animated: Bool) {
////        getDataFromYoutube(keyWord: "Hello")
//    }
    




    
//    func getDataFromYoutube(keyWord: String){
//
//
////        let request = VideoListRequest(part: [.id, .snippet, .contentDetails], filter: Filter.VideoList.id("Z3megGZrFMI"), maxResults: 1)
//        let requestSearch =
//"https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyWord)&maxResults=2&order=viewCount&key=AIzaSyAb6bz7DDzn_XVVGO2_M130Hu8096dZTe8"
//
//        AF.request(requestSearch).responseJSON { response in
//
//                switch response.result {
//                case .success(let json):
//
//                    let jsonObject = json as! [String:Any]
//                    let kind = jsonObject["kind"] as? String
//
//                    if kind != nil {
//                    let items = jsonObject["items"] as! NSArray
//                    let allitems = try! JSONSerialization.data(withJSONObject: items, options: [])
//                    let decoder = JSONDecoder()
//                    self.items.append(contentsOf: try! decoder.decode([Video].self, from: allitems))
//                    self.initViewData()
//
//                    }else{
//                        let errorMessage = jsonObject["message"] as! String
////                         completion(false,nil,errorMessage)
//                    }
//
//                    break
//                case .failure(let error):
//                    print("Error is: \(error.localizedDescription)")
//                }
//            }
//
//    }
    
