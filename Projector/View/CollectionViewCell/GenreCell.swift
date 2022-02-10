//
//  GenreCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 29.01.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {

    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backView.layer.borderWidth = 1.0
        backView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = 15.0
    }

}
