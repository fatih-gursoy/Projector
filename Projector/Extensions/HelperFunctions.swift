//
//  Layout_Functions.swift
//  Projector
//
//  Created by Fatih Gursoy on 29.01.2022.
//

import Foundation
import UIKit


extension UIViewController {
    
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


