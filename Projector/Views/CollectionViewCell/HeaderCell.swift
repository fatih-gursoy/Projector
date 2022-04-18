//
//  HDeneme.swift
//  Projector
//
//  Created by Fatih Gursoy on 7.02.2022.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    @IBOutlet private weak var headerLabel: UILabel!

    func configure(_ headerTitle: String) {
        headerLabel.text = headerTitle
        headerLabel.textColor = .lightGray
        headerLabel.font = .systemFont(ofSize: 20)
    }
    
    func didSelect(_ index:Int) {
        headerLabel.textColor = .black
        headerLabel.font = .boldSystemFont(ofSize: 20)
    }
    
    func didDeselect(_ index:Int) {
        headerLabel.textColor = .lightGray
        headerLabel.font = .systemFont(ofSize: 20)
    }
    
    
    
}
