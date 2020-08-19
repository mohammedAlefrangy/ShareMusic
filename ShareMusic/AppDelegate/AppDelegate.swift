//
//  AppDelegate.swift
//  ShareMusic
//
//  Created by Mohammed on 7/21/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseUI
import YoutubeKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        Thread.sleep(forTimeInterval: 0.001)
        // Override point for customization after application launch.
        FirebaseApp.configure()

        YoutubeKit.shared.setAPIKey("AIzaSyDPCv2BIZ9OXdXj0avV72QB3esEmzp9Vh0")
      
        
        return true
    }
    
 
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
         if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            
            let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String
            let annotation = options[UIApplication.OpenURLOptionsKey.annotation]
  
         }
         // other URL handling goes here.
         return false
    }
    




}

