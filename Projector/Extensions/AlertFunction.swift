//
//  Alert_Function.swift
//  Projector
//
//  Created by Fatih Gursoy on 16.02.2022.
//

import Foundation
import UIKit


extension UIViewController {
    
    func makeAlert(titleString: String, messageString: String) {
        
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
