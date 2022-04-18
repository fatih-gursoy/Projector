//
//  WebService.swift
//  Projector
//
//  Created by Fatih Gursoy on 26.01.2022.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol: AnyObject {
    
    func fetch<T:Decodable>(endpoint: EndPoint, model: T.Type, completion: @escaping (T?) -> Void)
    func fetchWithURL<T:Decodable>(endpoint: EndPoint, model: T.Type, completion: @escaping (T?) -> Void)

}

final class NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()
    
    private let apiKey = "1f24ae7390137fd409db68def75394e4"
    
    private init() {}
    
    func fetch<T:Decodable>(endpoint: EndPoint, model: T.Type, completion: @escaping (T?) -> Void) {
        
        let url = endpoint.baseURL + endpoint.path + "?api_key=\(apiKey)" + endpoint.body
        let request = AF.request(url)
        
        request.validate().responseDecodable(of: T.self) { response in

            guard let result = response.value else {return}
            completion(result)

        }
    }
    
    func fetchWithURL<T:Decodable>(endpoint: EndPoint, model: T.Type, completion: @escaping (T?) -> Void) {
        
        guard let url = URL(string: endpoint.baseURL + endpoint.path + "?api_key=\(apiKey)" + endpoint.body) else { return }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data = data else {
                return
            }
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result)
            } catch {
                print(error.localizedDescription)
            }

        }
        task.resume()
    }
    

    
//    func downloadMovies(listName: String, completion: @escaping (MovieList?) -> ()) {
//
//        let url = "\(API.baseURL)/movie/\(listName)?api_key=\(apiKey)"
//
//        let request = AF.request(url)
//
//        request.validate().responseDecodable(of: MovieList.self) { response in
//
//            guard let movieList = response.value else {return}
//            completion(movieList)
//
//        }
//
//    }
//
//    func downloadMovieDetail(movieId: String, completion: @escaping (Movie?) -> ()) {
//
//        let url = "\(API.baseURL)/movie/\(movieId)?api_key=\(apiKey)"
//
//        let request = AF.request(url)
//
//        request.validate().responseDecodable(of: Movie.self) { response in
//
//            guard let movie = response.value else {return}
//
//            completion(movie)
//        }
//    }
//
//    func downloadGenres(completion: @escaping (GenreList?) -> ()) {
//
//        let url = "\(API.baseURL)/genre/movie/list?api_key=\(apiKey)"
//
//        let request = AF.request(url)
//
//        request.validate().responseDecodable(of: GenreList.self) { response in
//
//                guard let genres = response.value else {return}
//
//                completion(genres)
//        }
//    }
//
//    func downloadCredits(movieId: String, completion: @escaping (Credits?) -> ()) {
//
//        let url = "\(API.baseURL)/movie/\(movieId)/credits?api_key=\(apiKey)"
//
//        let request = AF.request(url)
//
//        request.validate().responseDecodable(of: Credits.self) { response in
//
//            guard let credits = response.value else {return}
//
//            completion(credits)
//        }
//
//    }
//
//    func searchMovies(searchQuery: String, completion: @escaping (MovieList?) -> ()) {
//
//        let url = "\(API.baseURL)/search/movie?api_key=\(apiKey)&query=\(searchQuery)&include_adult=false"
//
//        let request = AF.request(url)
//
//        request.validate().responseDecodable(of: MovieList.self) { response in
//
//            guard let movieList = response.value else {return}
//            completion(movieList)
//
//        }
//    }
//
//    func downloadSimilarMovies(movieId: String, completion: @escaping (MovieList?) -> ()) {
//
//        let url = "\(API.baseURL)/movie/\(movieId)/similar?api_key=\(apiKey)"
//
//        let request = AF.request(url)
//
//        request.validate().responseDecodable(of: MovieList.self) { response in
//
//            guard let movieList = response.value else {return}
//            completion(movieList)
//
//        }
//    }
    
    
}
