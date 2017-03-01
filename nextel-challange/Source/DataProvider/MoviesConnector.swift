
import Alamofire
import Gloss
import UIKit

protocol MoviesConnectorProtocol {
    func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void )
    func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void )
}

enum MoviesConnectorError {
    case errorInSaveLocalFile
    case internetError
}

class MoviesConnector : MoviesConnectorProtocol {
    
    let moviesPersistence: MoviesPersistence
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    init(moviesPersistence: MoviesPersistence) {
        self.moviesPersistence = moviesPersistence
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
                        success(response.data!)
                    } else {
                        failure(.errorInSaveLocalFile)
                    }
                case .failure:
                    failure(.internetError)
                }
        }
    }
    
    func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
        
        let ago = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        
        let futureString = MoviesConnector.formatter.string(from: ago)
        let nowString = MoviesConnector.formatter.string(from: Date())
        
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
                        success(response.data!)
                    } else {
                        failure(.errorInSaveLocalFile)
                    }
                case .failure:
                    failure(.internetError)
                }
        }
    }
}

