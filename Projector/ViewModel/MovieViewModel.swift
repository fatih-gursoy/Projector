//
//  MovieViewModel.swift
//  Projector
//
//  Created by Fatih Gursoy on 10.04.2022.
//

import Foundation

protocol MovieViewModelDelegate: AnyObject {
    
    func updateUI()
}


class MovieViewModel {
    
    private var movie: Movie
    private var service: NetworkManagerProtocol
    weak var delegate: MovieViewModelDelegate?
    
    init(movie: Movie, service: NetworkManager = NetworkManager.shared) {
        self.movie = movie
        self.service = service
    }
    
    var movieTitle: String? {
        return movie.title
    }
    
    var overview: String? {
        return movie.overview
    }
    
    var id: String? {
        guard let id = movie.id else {return ""}
        return String(describing: id)
    }
    
    var genres: [Genre]? {
        return movie.genres
    }

    var photoURL: String? {
        return movie.posterPath
    }
    
    var isWatched: Bool? {
        get { return movie.isWatched }
        set { movie.isWatched = newValue }
    }
    
    var backdropURL: String? {
        
        return movie.backdropPath
    }
    
    var rating: Double {
        
        guard let rating = movie.voteAverage else {return 0.0}
        return rating
    }
    
    var voteCount: Int {
        
        guard let voteCount = movie.voteCount else {return 0}
        return voteCount
    }
    
    var runTime: Int {
        
        guard let runTime = movie.runtime else {return 0}
        return runTime
    }
    
    var year: String {
        
        let dt = DateFormatter()
        dt.dateFormat = "yyyy-MM-dd"
        guard let releaseDate = dt.date(from: movie.releaseDate ?? "") else {return  ""}
        
        dt.dateFormat = "yyyy"
        let year = dt.string(from: releaseDate)
        return year
    }
    
    func fetchMovieDetail(with id: String) {
        
        service.fetch(endpoint: MovieDetailEndPoint.movieDetail(id: id)) {
            [weak self] (movie: Movie) in
            
            self?.movie = movie
            
            DispatchQueue.main.async {
                self?.delegate?.updateUI()
            }
        }
    }
    
    func genreAtIndex(_ index: Int) -> GenreViewModel {
        guard let genre = self.genres?[index] else { fatalError("") }
        return GenreViewModel(genre: genre)
    }
    
}
