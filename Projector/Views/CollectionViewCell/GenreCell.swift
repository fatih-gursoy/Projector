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

//            if genre.isSelected == false || genre.isSelected == nil {
//                backView.backgroundColor = .clear
//                genreLabel.textColor = .black
//            } else if genre.isSelected == true {
//                backView.backgroundColor = .darkGray
//                genreLabel.textColor = .white
//            }
        }
    }
    
    func didSelect(_ index:Int) {
        
        backView.backgroundColor = .clear
        genreLabel.textColor = .black
        
    }
    
    func didDeselect(_ index:Int) {
        
        backView.backgroundColor = .darkGray
        genreLabel.textColor = .white
        
    }

}
