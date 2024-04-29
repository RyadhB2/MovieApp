import Foundation

struct Movie: Codable {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate : String
    let rating : Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}
