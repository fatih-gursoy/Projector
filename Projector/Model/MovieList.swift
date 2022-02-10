//
//  MovieList.swift
//  Projector
//
//  Created by Fatih Gursoy on 27.01.2022.
//

import Foundation

struct MovieList: Codable {
    
    var page: Int?
    var results: [Movie]
    var total_results: Int?
    var total_pages: Int?
    
}
