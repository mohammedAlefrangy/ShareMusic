//
//  FriendCVC.swift
//  ShareMusic
//
//  Created by Mohammed on 8/6/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import Foundation
import UIKit

class FriendCVC: UITableViewCell {
    //    Friend Requests
    
    @IBOutlet weak var imageUser  :UIImageView!
    @IBOutlet weak var nameFriend :UILabel!
    @IBOutlet weak var addFriend  :UIButton!
    @IBOutlet var ImageStatesUser : UIImageView!
    @IBOutlet var onlineOrOfline  : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
