//
//  ItemsYoutubeCVC.swift
//  ShareMusic
//
//  Created by Mohammed on 8/4/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import Foundation
import UIKit


class ItemsLaunchVideoCVC: UITableViewCell {
    
    @IBOutlet weak var imageVideo :UIImageView!
    @IBOutlet weak var titleVideo :UILabel!
    //@IBOutlet weak var discriptionVideo :UILabel!
    //  @IBOutlet weak var imageUser :UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //imageUser.contentMode = .scaleToFill
        //imageUser.layer.cornerRadius = (imageUser.frame.size.height)/2
        //imageUser.layer.masksToBounds = true
        //imageUser.clipsToBounds = true
        
        titleVideo.lineBreakMode = .byTruncatingMiddle
        titleVideo.adjustsFontSizeToFitWidth = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
