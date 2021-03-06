
import Alamofire
import Gloss
import UIKit

protocol MoviesConnectorProtocol {
    func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void )
    func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void )
    func searchMovieByOriginalTitle(query: String,
                                    success: @escaping (Data) -> Void,
                                    failure: @escaping (MoviesConnectorError) -> Void )
}

enum MoviesConnectorError {
    case errorInSaveLocalFile
    case internetError
}

class MoviesConnector : MoviesConnectorProtocol {
    
    let moviesPersistence: Persistence
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(moviesPersistence: Persistence) {
        self.moviesPersistence = moviesPersistence
    }
    
    func searchMovieByOriginalTitle(query: String,
                                    success: @escaping (Data) -> Void,
                                    failure: @escaping (MoviesConnectorError) -> Void ) {
        let params = ["api_key" : DataProvider.apiKey,
                      "query" : query]
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire
            .request(DataProvider.searchMoviePath, parameters: params)
            .validate()
            .responseString (queue: utilityQueue) { response in
                switch response.result {
                case .success:
                    DispatchQueue.main.async {
                        success(response.data!)
                    }
                case .failure:
                    DispatchQueue.main.async {
                        failure(.internetError)
                    }
                }
        }
    }
    
    func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
        
        let ago = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
        
        let agoString = MoviesConnector.formatter.string(from: ago)
        let nowString = MoviesConnector.formatter.string(from: Date())
        
        let params = ["api_key" : DataProvider.apiKey,
                      "primary_release_date.gte" : agoString,
                      "primary_release_date.lte" : nowString,
                      "vote_average.gte" : "5"]
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire
            .request(DataProvider.discoverMoviePath, parameters: params)
            .validate()
            .responseString(queue: utilityQueue) { response in
                switch response.result {
                case .success:
                    if self.moviesPersistence.saveFile(stringJson: response.result.value!, file: .nowPlayingMovies) {
                        DispatchQueue.main.async {
                            success(response.data!)
                        }
                    } else {
                        DispatchQueue.main.async {
                            failure(.errorInSaveLocalFile)
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        failure(.internetError)
                    }
                }
        }
    }
    
    func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
        
        let add = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        let add2 = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        
        let futureString = MoviesConnector.formatter.string(from: add)
        let nowString = MoviesConnector.formatter.string(from: add2)
        
        let params = ["api_key" : DataProvider.apiKey,
                      "primary_release_date.gte" : nowString,
                      "primary_release_date.lte" : futureString,
                      "vote_average.gte" : "5"]
        
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire
            .request(DataProvider.discoverMoviePath, parameters: params)
            .validate()
            .responseString(queue: utilityQueue) { response in
                switch response.result {
                case .success:
                    if self.moviesPersistence.saveFile(stringJson: response.result.value!, file: .upcomingMovies) {
                        DispatchQueue.main.async {
                            success(response.data!)
                        }
                    } else {
                        DispatchQueue.main.async {
                            failure(.errorInSaveLocalFile)
                        }
                    }
                case .failure:
                    DispatchQueue.main.async {
                        failure(.internetError)
                    }
                }
        }
    }
}

