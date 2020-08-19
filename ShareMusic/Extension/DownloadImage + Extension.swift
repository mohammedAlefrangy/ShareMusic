//
//  DownloadImage + Extension.swift
//  ShareMusic
//
//  Created by Mohammed on 7/29/20.
//  Copyright © 2020 Mohammed. All rights reserved.
//

import Foundation
import UIKit


extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .redraw) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
        }.resume()
    }
    
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .redraw) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
}
