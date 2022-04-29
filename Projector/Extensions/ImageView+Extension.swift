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
        
        let ImageBaseURL = "http://image.tmdb.org/t/p/w500"

        if let url = url {
            self.kf.setImage(with: URL(string: ImageBaseURL + url))
        }
    }
    
}

