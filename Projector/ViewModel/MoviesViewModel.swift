//
//  MoviesViewModel.swift
//  Projector
//
//  Created by Fatih Gursoy on 27.01.2022.
//

import Foundation

protocol MoviesViewModelDelegate: AnyObject {
    
    func updateMoviesView()
    
}

class MoviesViewModel {
    
    var movieList: [Movie] = []
    
    private let service: NetworkManagerProtocol
    weak var delegate: MoviesViewModelDelegate?
    
    init(service: NetworkManager = NetworkManager.shared) {
        self.service = service
    }
    
    var count : Int {
        return movieList.count
    }
    
    func movieAtIndex(_ index:Int) -> MovieViewModel {
        
        let movie = self.movieList[index]
        return MovieViewModel(movie: movie)
        
    }
    
    func fetchMovies(from endPoint: MoviesEndPoint) {
        
        service.fetch(endpoint: endPoint, model: MovieList.self) {
            [weak self] movies in
            
            guard let movies = movies else { return }
            self?.movieList = movies.results
            
            DispatchQueue.main.async {
                self?.delegate?.updateMoviesView()
            }
        }
    }
    
    func addMovie(movie: Movie) {

        movieList.append(movie)

    }
    
    var movieIdList: [String?] {
        
        let IdList = movieList.map { String(describing: $0.id) }
        return IdList
    
    }
    
    func filterByGenre(_ selectedGenres: [Genre]) -> [Movie] {
        
        var filteredMovies = [Movie]()
                
        for movie in movieList {
            
            for genre in selectedGenres {
                
                if (movie.genreIDs?.contains { $0 == genre.id } ) == true {
                    filteredMovies.append(movie)
                }
            }
        }
        return filteredMovies
    }

}




