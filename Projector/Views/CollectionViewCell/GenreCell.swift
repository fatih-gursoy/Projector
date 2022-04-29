//
//  GenreCell.swift
//  Projector
//
//  Created by Fatih Gursoy on 29.01.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {

    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var backView: UIView!
    
    func configure(viewModel: GenreViewModel?) {
        
        if let genre = viewModel {

            genreLabel.text = genre.genreTitle

        }
    }
    
    func didSelect(viewModel: GenreViewModel?) {
        
        if viewModel?.isSelected == true {
        
            backView.backgroundColor = .darkGray
            genreLabel.textColor = .white
            
        }
    }
    
    func didDeSelect(viewModel: GenreViewModel?) {

        if viewModel?.isSelected == false {
        
            backView.backgroundColor = .clear
            genreLabel.textColor = .black
            
        }
    }

}
