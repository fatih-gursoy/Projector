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
    
    func fetchMovies(from endPoint: EndPoint) {
        
        service.fetch(endpoint: endPoint) { [weak self] (movies: MovieList) in
            
            self?.movieList = movies.results
            
            DispatchQueue.main.async {
                self?.delegate?.updateMoviesView()
            }
        }
    }
    
    func addMovie(movieId: String?) {
        
        guard let movieId = movieId else { return }
        
        if !(movieList.contains(where: { String($0.id!) == movieId })) {
            
            service.fetch(endpoint: MovieDetailEndPoint.movieDetail(id: movieId)) { [weak self] (movie: Movie)  in
                
                self?.movieList.append(movie)
    
                DispatchQueue.main.async {
                    self?.delegate?.updateMoviesView()
                }
            }
        }
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




