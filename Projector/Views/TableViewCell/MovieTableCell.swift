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
    @IBOutlet private weak var watchButton: UIButton!
    
    func configure(viewModel: MovieViewModel?) {
        
        self.movieTitle.text = viewModel?.movieTitle ?? ""
        self.movieRating.text = (String(describing: viewModel?.rating))
        self.movieImage.setImage(url: viewModel?.photoURL)
        
        if let isWatched = viewModel?.isWatched {

            if isWatched {
                watchButton.setImage(UIImage(systemName: "eye.fill"), for: .normal)
            } else {
                watchButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            }
        }
        
    }
}
