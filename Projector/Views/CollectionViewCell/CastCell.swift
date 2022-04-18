//
//  CastCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 6.02.2022.
//

import UIKit

class CastCell: UICollectionViewCell {

    @IBOutlet private weak var castImage: UIImageView!
    @IBOutlet private weak var castName: UILabel!
    @IBOutlet private weak var castRole: UILabel!
    
    func configure(viewModel: CreditViewModel?) {
        
        if let viewModel = viewModel {

            castName.text = viewModel.cast.name
            castRole.text = viewModel.cast.character

            if let photoURL = viewModel.cast.profilePath {
                castImage.setImage(url: photoURL)
            }
            
        }
    }
    
    

}
