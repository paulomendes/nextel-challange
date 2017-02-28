
import Alamofire
import Gloss

protocol MoviesConnectorProtocol {
    func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void )
}

enum MoviesConnectorError {
    case errorInSaveLocalFile
    case internetError
}

class MoviesConnector : MoviesConnectorProtocol {
    
    let moviesPersistence: MoviesPersistence
    
    init(moviesPersistence: MoviesPersistence) {
        self.moviesPersistence = moviesPersistence
    }
    
    func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
        let params = ["api_key" : DataProvider.apiKey]
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        Alamofire
            .request(DataProvider.movieNowPlaying, parameters: params)
            .validate()
            .responseString(queue: utilityQueue) { response in
            switch response.result {
            case .success:
                if self.moviesPersistence.saveFile(stringJson: response.result.value!) {
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

