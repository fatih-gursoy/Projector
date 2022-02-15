//
//  Constants.swift
//  Projector
//
//  Created by Fatih Gursoy on 3.02.2022.
//

import Foundation
import UIKit

enum Header: String, CaseIterable {

    case nowPlaying = "now_playing"
    case popular = "popular"
    case topRated = "top_rated"
    case upcoming = "upcoming"

    var headerTitle: String {
        
        switch self {
            case .nowPlaying: return "Now Playing"
            case .upcoming: return "Upcoming"
            case .topRated: return "Top Rated"
            case .popular: return "Popular"
        }
    }
}

struct API {
    
    static let baseURL = "https://api.themoviedb.org/3"
    static let ImageBaseURL = "http://image.tmdb.org/t/p/w500"
    static let backdropBaseURL = "http://image.tmdb.org/t/p/w780"
    
}




