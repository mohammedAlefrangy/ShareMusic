//
//  UIViewController+Extention.swift
//  ShareMusic
//
//  Created by Mohammed on 8/10/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func showAlertMessage(title: String = "", message :String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
