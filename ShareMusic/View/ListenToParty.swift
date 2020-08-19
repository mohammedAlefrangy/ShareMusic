//
//  ListenToParty.swift
//  ShareMusic
//
//  Created by Mohammed on 8/9/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth


class ListenToParty: UIViewController {
    
    
    static func getKeyForCureentUser() -> (String , String) {
        let defaults = UserDefaults.standard
        var key: String
        var videdId: String?
        var status: String?
        
        let reference = Database.database().reference().child("User").queryOrdered(byChild: "email")
        let emailUser = Auth.auth().currentUser?.email
        reference.queryEqual(toValue: emailUser).observe(.value) { (dataSnapshot) in
            
            
            for user in dataSnapshot.children{
                let userChild = user as! DataSnapshot
                let userValue = userChild.value as! [String: Any]
                let key = userChild.key
                if key != nil{
                    defaults.set(key, forKey: "key")
                    let listenToParty = self.listenToParty(keyCurrentUser: key)
                    videdId = listenToParty.0
                    status = listenToParty.1
                    print("\(videdId)")
                    
                }
            }
        }
        return (videdId ?? "", status ?? "")
    }
    
    static func listenToParty(keyCurrentUser: String) -> (String , String){
        var videdId: String?
        var status: String?
        let reference = Database.database().reference().child("Party").queryOrdered(byChild: "keyHosted")
        reference.queryEqual(toValue: keyCurrentUser).observe(.value) { (dataSnapshot) in
            
            for user in dataSnapshot.children{
                let userChild = user as! DataSnapshot
                let userValue = userChild.value as! [String: Any]
                
                let keyMangerUser = userValue["keyMangerUser"] as! String
                let keyHosted = userValue["keyHosted"] as! String
                videdId = userValue["videdId"] as! String
                status = userValue["Status"] as! String
                
                //                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                        let vc = storyboard.instantiateViewController(withIdentifier: "LaunchVideoVC") as! LaunchVideoVC
                //                        vc.id = videdId
                //                        vc.status = status
                //                        self.present(vc, animated: true, completion: nil)
                
                //                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LaunchVideoVC") as! LaunchVideoVC
                //                        vc.id = videdId
                //                        vc.status = status
                //                        self.present(vc, animated: true, completion: nil)
            }
            
        }
        return (videdId ?? "", status ?? "")
        
    }
    
}
