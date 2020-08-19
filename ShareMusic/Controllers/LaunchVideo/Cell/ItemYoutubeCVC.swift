//
//  ItemYoutubeCVC.swift
//  ShareMusic
//
//  Created by Mohammed on 7/28/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit

class ItemYoutubeCVC: UITableViewCell {
    
    @IBOutlet weak var videoImage :UIImageView!
    @IBOutlet weak var videoTitle :UILabel!
    @IBOutlet weak var videoDiscreption :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
