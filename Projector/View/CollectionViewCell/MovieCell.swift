//
//  CollectionViewCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 29.01.2022.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
    }
    
    override func layoutSubviews() {

        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 20, height: 20)
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }


}
