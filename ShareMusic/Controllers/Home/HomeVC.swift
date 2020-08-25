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
import Alamofire
import Firebase
import FirebaseDatabase
import FirebaseAuth


class HomeVC: UIViewController {
    
    
    var homeData :[Home] = []
    var items = [Video]()
    
    @IBOutlet weak var collectionView :UICollectionView!
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        saveDataFromFireBase()
        getDataFromYoutube(keyWord: "Hello")
    }
    
    func initViewData(){
        saveDataFromFireBase()
        initTableView()
    }
    
    
    
    
    func saveDataFromFireBase(){
        
        let reference = Database.database().reference().child("User").queryOrdered(byChild: "email")
        let emailUser = Auth.auth().currentUser?.email
        reference.queryEqual(toValue: emailUser).observe(.value) { (dataSnapshot) in
            for user in dataSnapshot.children{
                let userChild = user as! DataSnapshot
                let key = userChild.key
                
                self.defaults.set(key, forKey: "key")
            }
        }
    }
    
    
    func getDataFromYoutube(keyWord: String){

        let requestSearch =
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(keyWord)&maxResults=6&order=viewCount&key=\(APIConfig.apiKey3)"
        print("The request is: \(requestSearch)")
        
        AF.request(requestSearch).responseJSON { response in
            
            switch response.result {
            case .success(let json):
                let jsonObject = json as! [String:Any]
                let kind = jsonObject["kind"] as? String
                if kind != nil {
                    let items = jsonObject["items"] as! NSArray
                    let allitems = try! JSONSerialization.data(withJSONObject: items, options: [])
                    let decoder = JSONDecoder()
                    self.items.append(contentsOf: try! decoder.decode([Video].self, from: allitems))
                    print(self.items.count)
                    self.collectionView.reloadData()
                    self.initViewData()
                    
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
    
}


extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func initTableView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC1", for: indexPath) as! HomeCVC
            cell.titleVideo.text = items[indexPath.row].snippet?.title
            let url = URL(string: items[indexPath.row].snippet?.thumbnails?.high?.url ?? "")
            cell.imageVideo.downloadedFrom(url: url!)
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCVC2", for: indexPath) as! HomeCVC
            cell.titleVideo.text = items[indexPath.row].snippet?.title
            let url = URL(string: items[indexPath.row].snippet?.thumbnails?.high?.url ?? "")
            cell.imageVideo.downloadedFrom(url: url!)
            
            return cell
            
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.row == 0 {

            let width  = (view.frame.width)
            let height  = (view.frame.width)/2
            return CGSize(width: width, height: height)
            
        } else {
            let width  = (view.frame.width-40)/2
            let height  = (view.frame.width)/2
            return CGSize(width: width, height: height)
        }
         
     }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FriendVC") as! FriendVC
        vc.videdId = self.items[indexPath.row].id?.videoID
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
