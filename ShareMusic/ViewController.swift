//
//  ViewController.swift
//  ShareMusic
//
//  Created by Mohammed on 7/21/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseUI


class ViewController: UIViewController, FUIAuthDelegate{
    
    let authUI = FUIAuth.defaultAuthUI()
    var user:User!
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titel: UILabel!
    @IBOutlet weak var providerTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Back Buttom item in navigation bar
        self.navigationItem.hidesBackButton = true
        
        // add sign out button in navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Signout", style: .plain, target: self, action: #selector(self.signOutButtonPressed))
        
        // send all data for user to function to show the data in the lable
        showProfileView(user: user)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationItem.hidesBackButton = true
    }
    
    
    @objc func signOutButtonPressed() {
              // Sign out method
              do {
                
                try authUI?.signOut()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.navigationController?.pushViewController(vc, animated: true)
                
              } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
              }
      }
    
   
    func showProfileView(user:User) {
        
        if let userProfileImg = user.photoURL {
            if let data = try? Data(contentsOf: userProfileImg) {
                img.image = UIImage(data: data)
            }
            img.frame = CGRect(x:view.frame.size.width / 2 - 50, y:150, width:100, height:100)
            img.layer.cornerRadius = 50
            img.clipsToBounds = true
        }
        
        if let userTitle = user.displayName {
            titel.text = userTitle
            titel.frame = CGRect(x:0, y:250, width:view.frame.size.width, height:40)
            titel.textAlignment = .center
            titel.font = UIFont.systemFont(ofSize: 20)
        }
     
        providerTitle.text = "Logged in via: \(user.providerData[0].providerID)"
        providerTitle.frame = CGRect(x:0, y:275, width:view.frame.size.width, height:40)
        providerTitle.textAlignment = .center
        providerTitle.font = UIFont.systemFont(ofSize: 16)
        providerTitle.textColor = .gray
        
    }
    
    
}

