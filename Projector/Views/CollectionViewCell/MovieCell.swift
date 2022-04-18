//
//  CollectionViewCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 29.01.2022.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieTitleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    

    func configure(viewModel: MovieViewModel?) {
        
        if let movie = viewModel {

            movieTitleLabel.text = movie.movieTitle

            if let posterPath = movie.photoURL {
                movieImageView.setImage(url: posterPath)
            }
            ratingLabel.text = String(describing: movie.rating)
        }
    }
    
}
