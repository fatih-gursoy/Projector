//
//  Layout_Functions.swift
//  Projector
//
//  Created by Fatih Gursoy on 29.01.2022.
//

import Foundation
import UIKit

func cellLayout(_ image: UIImageView) {
    
    image.layer.cornerRadius = 30.0
    image.layer.backgroundColor = UIColor.white.cgColor
    image.layer.borderWidth = 0.5
    image.layer.borderColor = UIColor.clear.cgColor
    image.layer.shadowColor = UIColor.black.cgColor
    image.layer.shadowOffset = CGSize(width: 3, height: 3)
    image.layer.shadowRadius = 4.0
    image.layer.shadowOpacity = 0.7
    image.layer.masksToBounds = true
}

extension UIViewController {
    
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
