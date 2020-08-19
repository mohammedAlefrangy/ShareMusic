//
//  FriendVC.swift
//  ShareMusic
//
//  Created by Mohammed on 8/6/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth


class FriendVC: UIViewController {
    
    @IBOutlet weak var tableViewFriends: UITableView!
    var friendsArray: [Friends] = []
    let defaults = UserDefaults.standard
    var videdId: String!
    var refernceFireBase = Database.database().reference()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        initTableView()
        getKeyForCureentUser()
        
    }
    
    
    func getKeyForCureentUser() {
        var key: String
        
        let reference = refernceFireBase.child("User").queryOrdered(byChild: "email")
        let emailUser = Auth.auth().currentUser?.email
        reference.queryEqual(toValue: emailUser).observe(.value) { (dataSnapshot) in
            
            
            for user in dataSnapshot.children{
                let userChild = user as! DataSnapshot
                let userValue = userChild.value as! [String: Any]
                let key = userChild.key
                self.defaults.set(key, forKey: "key")
                self.listenToParty(keyCurrentUser: key)
                
            }
        }
    }
    
    func listenToParty(keyCurrentUser: String){
        let reference = refernceFireBase.child("Party").queryOrdered(byChild: "keyHosted")
        reference.queryEqual(toValue: keyCurrentUser).observe(.value) { (dataSnapshot) in
            
            for user in dataSnapshot.children{
                
                let userChild = user as! DataSnapshot
                let userValue = userChild.value as! [String: Any]
                let keyMangerUser = userValue["keyMangerUser"] as! String
                let keyHosted = userValue["keyHosted"] as! String
                let videdId = userValue["videdId"] as! String
                let status = userValue["Status"] as! String
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVideoVC") as! LaunchVideoVC
                vc.videdId = videdId
                vc.status = status
                vc.partyStrat = true
                vc.keyCurrentUser = keyCurrentUser
                self.navigationController!.pushViewController(vc, animated: true)
            }
            
        }
    }
    
    func sendRequest(keyHosted: String) {
        
        let keyMangerUser = defaults.string(forKey: "key")
        
        var requestObj = [String: Any]()
        requestObj["keyMangerUser"] = keyMangerUser
        requestObj["keyHosted"] = keyHosted
        requestObj["videdId"] = videdId
        requestObj["Status"] = "playing"
        
        refernceFireBase.child("Party").child(keyMangerUser ?? "").setValue(requestObj)
    }
    
    // get All user from fireBase and show in tableView
    func getAllUsers() {
        
        refernceFireBase.child("User").observe(.value){
            (dataSnapshot) in
            
            self.friendsArray.removeAll()
            for child in dataSnapshot.children{
                
                let userChild = child as! DataSnapshot
                let userValue = userChild.value as! [String: Any]
                
                let id = userChild.key  // key for Users how in database
                let profileImage = userValue["profileImage"] as! String
                let name = userValue["name"] as! String
                let email = userValue["email"] as! String
                let isOnline = userValue["isOnline"] as! String
                
                // get key for current user from UserDefaultas to check if equal id or not : if equle don't put in List of friend tableView
                let keyCurrentUser = UserDefaults.standard.string(forKey: "key")
                
                if keyCurrentUser?.elementsEqual(id) ?? false{
                    print("I'm Here")
                }else{
                    self.friendsArray.append(Friends(id: id, image: profileImage, name: name, email: email, isOnline: isOnline))
                    self.tableViewFriends.reloadData()
                }
            }
        }
    }
    
}






extension FriendVC: UITableViewDelegate, UITableViewDataSource{
    
    func initTableView(){
        tableViewFriends.dataSource = self
        tableViewFriends.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewFriends.dequeueReusableCell(withIdentifier: "FriendCVC", for: indexPath) as! FriendCVC
        
        cell.nameFriend.text = friendsArray[indexPath.row].name
        
        if friendsArray[indexPath.row].isOnline.elementsEqual("true"){
            cell.onlineOrOfline.text = "Online"
            cell.ImageStatesUser.tintColor = UIColor.green
            cell.isUserInteractionEnabled = true
            
        }else{
            cell.onlineOrOfline.text = "Offline"
            cell.ImageStatesUser.tintColor = UIColor.red
            cell.isUserInteractionEnabled = false
        }
        
        //        let url = URL(string: userArray[indexPath.row].image ?? "")
        //        do{
        //            let urlString = try String(contentsOf: url!, encoding: .ascii)
        //            cell.imageUser.downloadedFrom(link: urlString)
        //        }catch let error{
        //            print(error.localizedDescription)
        //        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.videdId != nil {
            
            let user = friendsArray[indexPath.row]
            let userId = user.id
            let emailSelect = user.email
            
            let reference = refernceFireBase.child("User").queryOrdered(byChild: "email")
            
            reference.queryEqual(toValue: emailSelect).observeSingleEvent(of: .value) { (dataSnapshot) in
                
                for user in dataSnapshot.children{
                    let userChild = user as! DataSnapshot
                    let userValue = userChild.value as! [String: Any]
                    let key = userChild.key
                    self.sendRequest(keyHosted: key)
                }
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVideoVC") as! LaunchVideoVC
            vc.videdId = videdId
            vc.status = "play"
            self.navigationController!.pushViewController(vc, animated: true)
            
        }else{
            self.showAlertMessage(message:"Please choice music befor start party")
        }
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addFrined = UIContextualAction(style: .destructive, title: "Add Friend") {
            (_,_,_) in
            print("ADD")
        }
        addFrined.image = UIImage(systemName: "add")
        
        return UISwipeActionsConfiguration(actions: [addFrined])
    }
    
    
}
