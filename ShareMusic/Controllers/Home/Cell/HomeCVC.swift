//
//  ItemYoutubeCVC.swift
//  ShareMusic
//
//  Created by Mohammed on 7/28/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import UIKit

class HomeCVC: UICollectionViewCell {
    
    
    @IBOutlet weak var imageVideo :UIImageView!
    @IBOutlet weak var titleVideo :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        titleVideo.lineBreakMode = .byTruncatingMiddle
        titleVideo.adjustsFontSizeToFitWidth = true
    }
    
}
