//
//  ProfileVC.swift
//  ShareMusic
//
//  Created by Mohammed on 8/6/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import Reachability

class ProfileVC: UIViewController , FUIAuthDelegate{
    
    let authUI = FUIAuth.defaultAuthUI()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var mobileNumber: UILabel!
    
    let reachability = try! Reachability()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                print("Wifi Connected")
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                print("No Internet Connected")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(internetChanged), name: .reachabilityChanged , object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("Could not start Notifier")
        }
        
        // send all data for user to function to show the data in the lable
        showProfileView(user: Auth.auth().currentUser!)
        
        
    }
    
    @objc func internetChanged(note: Notification){
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
            
         case .wifi:
             DispatchQueue.main.async {
                 print("Wifi Connected")
             }
        case .cellular:
             DispatchQueue.main.async {
                 print("MobileData Connected")
             }
         case .unavailable:
            DispatchQueue.main.async {
            print("No Internet Connected")
         }
            
        case .none:
            print("none")
        }
    
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    @IBAction func logOut(_ sender: Any) {
        // Sign out method
        do {
            try! authUI?.signOut()
            checkStateForUsers()
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
            UserDefaults.standard.synchronize()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
            self.present(vc, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func checkStateForUsers(){
        
        let keyCurrentUser = UserDefaults.standard.string(forKey: "key")
        let reference = Database.database().reference().child("User")
        
        reference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(keyCurrentUser!){
                print("Yeeeees")
                let ref = reference.child(keyCurrentUser!).child("isOnline")
                ref.setValue("false")
            }else{
                print("false doesn't exist")
            }
        })
    }
    
    
    func showProfileView(user:User) {
        
        if let userProfileImg = user.photoURL {
            if let data = try? Data(contentsOf: userProfileImg) {
                img.image = UIImage(data: data)
            }
            img.layer.cornerRadius = 50
            img.clipsToBounds = true
        }
        
        if let userTitle = user.displayName {
            userName.text = userTitle
            fullName.text = userTitle
        }
        
        userEmail.text = user.email
        mobileNumber.text = user.phoneNumber
        
        
    }
    
    
}
