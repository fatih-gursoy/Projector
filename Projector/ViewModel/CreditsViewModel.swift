//
//  CreditsViewModel.swift
//  Projector
//
//  Created by Fatih Gursoy on 6.02.2022.
//

import Foundation

protocol CreditsViewModelDelegate: AnyObject {

    func updateCastCollectionView()
}
    
class CreditsViewModel {
    
    var cast: [Cast]?
    var crew: [Cast]?
    
    weak var delegate: CreditsViewModelDelegate?
    private var service: NetworkManagerProtocol
    
    init(service: NetworkManager = NetworkManager.shared) {
        self.service = service
    }
    
    func fetchCredits(with id: String) {
        
        service.fetch(endpoint: MovieDetailEndPoint.credits(id: id)) {
            [weak self] (credits: Credits) in
            
            self?.cast = credits.cast
            self?.crew = credits.crew
            
            DispatchQueue.main.async {
                self?.delegate?.updateCastCollectionView()
            }
        }
    }
    
    func castAtIndex(_ index: Int) -> CreditViewModel {
        
        guard let cast = cast?[index] else { fatalError("Error") }
        return CreditViewModel(cast: cast)
        
    }
    
}

class CreditViewModel {
    
    var cast: Cast
    
    init(cast: Cast) {
        self.cast = cast
    }
    
 
}
