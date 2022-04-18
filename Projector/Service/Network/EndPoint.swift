//
//  EndPoint.swift
//  Projector
//
//  Created by Fatih Gursoy on 12.04.2022.
//

import Foundation

protocol EndPoint {
    
    var baseURL: String { get }
    var path: String { get }
    var body: String { get }
    
}

extension EndPoint {
    
    var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }

}

enum MoviesEndPoint: CaseIterable {

    case nowPlaying
    case popular
    case topRated
    case upcoming
    
    var headerTitle: String {

        switch self {
            case .nowPlaying: return "Now Playing"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            case .popular: return "Popular"
        }
    }
}

extension MoviesEndPoint: EndPoint {
    
    var path: String {
        
        switch self {
            
        case .nowPlaying:
            return "movie/now_playing"
            
        case .popular:
            return "movie/popular"
            
        case .topRated:
            return "movie/top_rated"
            
        case .upcoming:
            return "movie/upcoming"
            
        }
    }
    
    var body: String {
        
        switch self {
        case .nowPlaying, .popular, .topRated, .upcoming:
            return ""
        }
    }
    
}

enum MovieDetailEndPoint {
    
    case movieDetail(id: String)
    case genres
    case credits(id: String)
    case similarMovies(id: String)
    case search(query: String)
    
}

extension MovieDetailEndPoint: EndPoint {
    
    var path: String {
        
        switch self {
            
        case .movieDetail(let id):
            return "movie/\(id)"
            
        case .genres:
            return "genre/movie/list"
            
        case .credits(let id):
            return "movie/\(id)/credits"
            
        case .similarMovies(let id):
            return "movie/\(id)/similar"
            
        case .search(_):
            return "search/movie/"

        
        }
        
    }
    
    
    var body: String {
        
        switch self {
            
        case .search(let query):
            return "&query=\(query)&include_adult=false"
            
        default:
            return ""
        }
    }

}



    

    



