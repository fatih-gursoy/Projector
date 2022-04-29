//
//  MovieTableCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 8.02.2022.
//

import UIKit

class MovieTableCell: UITableViewCell {

    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var movieTitle: UILabel!
    @IBOutlet private weak var movieRating: UILabel!
    
    func configure(viewModel: MovieViewModel?) {
                
        self.movieTitle.text = viewModel?.movieTitle ?? ""
        
        if let rating = viewModel?.rating {
            self.movieRating.text = "\(rating)"
        }
        
        self.movieImage.setImage(url: viewModel?.photoURL)
        
    }
}
