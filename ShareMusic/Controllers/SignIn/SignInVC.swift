//
//  SignInVC.swift
//  ShareMusic
//
//  Created by Mohammed on 7/22/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI
import LGButton

class SignInVC: UIViewController, FUIAuthDelegate {
    let authUI = FUIAuth.defaultAuthUI()
    
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        // Create Image View and add cornerRadius
        logoImage.contentMode = .scaleAspectFit
        logoImage.layer.cornerRadius = (logoImage.frame.size.height)/2
        logoImage.layer.masksToBounds = true
        logoImage.clipsToBounds = true
        
    }
    
    // When click login button show Firebase UI to login
    @IBAction func action(_ sender: LGButton) {
        sender.isLoading = true
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            sender.isLoading = false
            
            //FireBase UI
            let providers: [FUIAuthProvider] = [
                FUIEmailAuth(),
                FUIGoogleAuth(),
                FUIFacebookAuth(),
                FUIPhoneAuth(authUI: FUIAuth.defaultAuthUI()!),
                FUIOAuth.twitterAuthProvider()]
            
            self.authUI!.providers = providers
            
            // verfiyEmail to check if email verify or not
            self.verifyEmail()
            
        }
    }
    
    // When the user login save all data in the realtime database
    func addUserInDataBase(user: User) {
        let emailUser = user.email
        
        let profileImage = user.photoURL
        guard let url = profileImage else { return }
        
        //initi dictinory to add in realtime database
        var userObj = [String: Any]()
        userObj["name"] = user.displayName
        userObj["email"] = emailUser
        userObj["isOnline"] = "true"
        userObj["profileImage"] = url.absoluteString
        
        // get the key for the current user to check if exist in database or not
        let reference = Database.database().reference().child("User").queryOrdered(byChild: "email").queryEqual(toValue: emailUser)
        reference.observeSingleEvent(of: .value) { (sanpshot) in
            if sanpshot.exists() {
                for user in sanpshot.children{
                    print("The User is Alerady exists")
                                        let userChild = user as! DataSnapshot
                                        let key = userChild.key
                                        let ref = Database.database().reference().child("User").child(key).child("isOnline")
                                        ref.setValue("true")
                }
            }else{
                Database.database().reference().child("User").childByAutoId().setValue(userObj)
            }
        }
    }
    
    //check if email is verify or not if verify save in database else show authViewController
    func verifyEmail()  {
        Auth.auth().addStateDidChangeListener{(auth, user) in
            if Auth.auth().currentUser?.isEmailVerified ?? false {
                self.addUserInDataBase(user: user!)
                self.dismiss(animated: true, completion: nil)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBar")
                self.present(vc!, animated: true, completion: nil)
            } else {
                let authViewController = self.authUI!.authViewController();
//                self.addUserInDataBase(user: user!)
                self.present(authViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    
}
