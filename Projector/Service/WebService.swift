//
//  WebService.swift
//  Projector
//
//  Created by Fatih Gursoy on 26.01.2022.
//

import Foundation
import Alamofire

class WebService {

    private let apiKey = Keys.apiKey
    
    func downloadMovies(listName: String, completion: @escaping (MovieList?) -> ()) {
    
        let url = "\(API.baseURL)/movie/\(listName)?api_key=\(apiKey)"
        
        let request = AF.request(url)
        
        request.validate().responseDecodable(of: MovieList.self) { response in

            guard let movieList = response.value else {return}
            completion(movieList)

        }
        
    }
    
    func downloadMovieDetail(movieId: String, completion: @escaping (Movie?) -> ()) {
    
        let url = "\(API.baseURL)/movie/\(movieId)?api_key=\(apiKey)"
        
        let request = AF.request(url)
        
        request.validate().responseDecodable(of: Movie.self) { response in

            guard let movie = response.value else {return}

            completion(movie)
        }
        
    }
    
    func downloadGenres(completion: @escaping (GenreList?) -> ()) {
        
        let url = "\(API.baseURL)/genre/movie/list?api_key=\(apiKey)"
                
        let request = AF.request(url)
        
        request.validate().responseDecodable(of: GenreList.self) { response in

                guard let genres = response.value else {return}
                
                completion(genres)
        }
    }
        
    func downloadCredits(movieId: String, completion: @escaping (Credits?) -> ()) {
    
        let url = "\(API.baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)"
        
        let request = AF.request(url)
        
        request.validate().responseDecodable(of: Credits.self) { response in

            guard let credits = response.value else {return}

            completion(credits)
        }
        
    }
    
    func searchMovies(searchQuery: String, completion: @escaping (MovieList?) -> ()) {
    
        let url = "\(API.baseURL)/search/movie?api_key=\(apiKey)&query=\(searchQuery)&include_adult=false"
        
        let request = AF.request(url)
        
        request.validate().responseDecodable(of: MovieList.self) { response in

            guard let movieList = response.value else {return}
            completion(movieList)

        }
        
    }
    
    
}
