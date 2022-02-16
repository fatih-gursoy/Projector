//
//  CastCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 6.02.2022.
//

import UIKit

class CastCell: UICollectionViewCell {

    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var castRole: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()

        castImage.layer.cornerRadius = castImage.frame.width / 2
        castImage.layer.borderWidth = 0
        castImage.clipsToBounds = true

    }
    

}
