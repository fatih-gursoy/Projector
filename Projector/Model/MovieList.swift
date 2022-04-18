//
//  MovieList.swift
//  Projector
//
//  Created by Fatih Gursoy on 27.01.2022.
//

import Foundation

struct MovieList: Codable {
    
    let page: Int?
    let results: [Movie]
    let total_results: Int?
    let total_pages: Int?
    
}
