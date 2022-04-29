//
//  ImageView+Extension1.swift
//  Projector
//
//  Created by Fatih Gursoy on 8.04.2022.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: String?) {
        
        if let url = url {
            self.kf.setImage(with: URL(string: API.ImageBaseURL + url))
        }
    }
    
}

