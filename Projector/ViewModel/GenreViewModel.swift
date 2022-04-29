//
//  GenreViewModel.swift
//  Projector
//
//  Created by Fatih Gursoy on 10.04.2022.
//

import Foundation

class GenreViewModel {
    
    private var genre: Genre
    
    init(genre: Genre) {
        self.genre = genre
    }
    
    var genreTitle: String? {
        return genre.name
    }
    
    var genreId: String? {
        return String(describing: genre.id)
    }
    
    var isSelected: Bool? {
        return genre.isSelected
    }
    
}


// -MARK: GenresViewModel

protocol GenresViewModelDelegate: AnyObject {
    
    func updateGenreView()
    
}

class GenresViewModel {
    
    var genreList: [Genre] = []
    
    private var service: NetworkManagerProtocol
    weak var delegate: GenresViewModelDelegate?
    
    init(service: NetworkManager = NetworkManager.shared) {
        self.service = service
    }
    
    func fetchGenres() {
        
        service.fetch(endpoint: MovieDetailEndPoint.genres) {
            [weak self] (genreList: GenreList) in
            
            guard let genres = genreList.genres else {return}
            self?.genreList = genres

            DispatchQueue.main.async {
                self?.delegate?.updateGenreView()
            }
        }
    }

    func genreAtIndex(_ index: Int) -> GenreViewModel {
        let genre = self.genreList[index]
        return GenreViewModel(genre: genre)
    }
    
    func selectGenreAtIndex(_ index:Int) {
        
        if let selection = self.genreList[index].isSelected {
            self.genreList[index].isSelected = !selection
        } else {
            self.genreList[index].isSelected = true
        }
    }
    
}
