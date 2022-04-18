
import Foundation

struct Movie: Codable {
    
    let adult: Bool?
    let backdropPath: String?
    let budget: Int?
    let genres: [Genre]?
    let genreIDs: [Int]?
    let homepage: String?
    let id: Int?
    let imdbID, originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let status, tagline, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    var isWatched: Bool?   // bunu Coredata'dan gelen veri ile değiştiriyorum ?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case budget, genres, homepage, id
        case genreIDs = "genre_ids"
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case runtime
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case isWatched
    }
}

// MARK: - Genre
struct Genre: Codable {
    
    let id: Int?
    let name: String?
    var isSelected: Bool?
    
}

struct GenreList: Codable {
    let genres: [Genre]?
}




