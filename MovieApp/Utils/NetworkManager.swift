

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    private let apiKey = "c9856d0cb57c3f14bf75bdc6c063b8f3"
    private let baseURL = "https://api.themoviedb.org/3"
    private var page = 1
    
    private init() {}
    
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = "\(baseURL)/movie/popular"
        let parameters: [String: Any] = ["api_key": apiKey,"page" : page]
        
        AF.request(url, parameters: parameters).responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let movieResponse):
                completion(.success(movieResponse.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let url = "\(baseURL)/movie/\(movieId)"
        let parameters: [String: Any] = ["api_key": apiKey]
        
        AF.request(url, parameters: parameters).responseDecodable(of: Movie.self) { response in
            switch response.result {
            case .success(let movieDetail):
                completion(.success(movieDetail))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
