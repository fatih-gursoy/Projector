//
//  MovieTableCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 8.02.2022.
//

import UIKit

class MovieTableCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImage.layer.shadowColor = UIColor.darkGray.cgColor
        movieImage.layer.shadowOffset = CGSize(width: 20, height: 20)
        movieImage.layer.shadowRadius = 10.0
        movieImage.layer.shadowOpacity = 0.5
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 10.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
