//
//  MoviesViewModel.swift
//  Projector
//
//  Created by Fatih Gursoy on 27.01.2022.
//

import Foundation
import Alamofire

struct MoviesViewModel {
    
    let movieList: [Movie]
    
    var count : Int {
        return movieList.count
    }
    
    func movieAtIndex(_ index:Int) -> MovieViewModel {
        
        let movie = self.movieList[index]
        return MovieViewModel(movie: movie)
        
    }
    
    var movieIdList: [String?] {
        
        let Ids = movieList.map { movie in
           String(describing: movie.id)
        }
        return Ids
    }
    
    func filterByGenre(_ selectedGenres: [Genre]) -> [Movie] {
        
        var filteredMovies = [Movie]()
        
        for movie in movieList {
            for genre in selectedGenres {
                
                if (movie.genreIDS?.contains { $0 == genre.id } ) == true {
                    filteredMovies.append(movie)
                }
            }
        }
        return filteredMovies
    }

}

struct MovieViewModel {
    
    let movie: Movie
    
    var MovieTitle: String? {
        return movie.title
    }
    
    var id: String? {
        
        guard let id = movie.id else {return ""}
        return String(describing: id)
    }
    
    var photoURL: String? {
        
        return movie.posterPath
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

    
}

struct GenreViewModel {
    
    let genreList: [Genre]?
    
}
