
import UIKit
import Gloss

enum MoviesDAOError {
    case connectionError
    case fileError
    case parserError
}

protocol MoviesDAOProtocol {
    func getNowPlayingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void)
    func getUpcomingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void)
    func searchMovieByTitle(query: String, success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void)
}

class MoviesDAO : MoviesDAOProtocol {
    
    let moviesPersistence: Persistence
    let moviesConnector: MoviesConnectorProtocol
    
    init(moviesPersistence: Persistence, connector: MoviesConnectorProtocol) {
        self.moviesPersistence = moviesPersistence
        self.moviesConnector = connector
    }
    
    func getNowPlayingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
        self.moviesPersistence.readFile(file: .upcomingMovies) { (fileData, err) in
            if err == .fileNotFound || err == .invalidFileFormat || err == .invalidCache {
                self.moviesConnector.getNowPlayingMovies(success: { moviesData in
                    let movies = self.convertDataIntoModel(data: moviesData)
                    if movies.count > 0 {
                        success(movies)
                    } else {
                        failure(.parserError)
                    }
                }, failure: { err in
                    switch err {
                    case .internetError:
                        failure(.connectionError)
                    case .errorInSaveLocalFile:
                        failure(.fileError)
                    }
                })
            } else {
                let movies = self.convertDataIntoModel(data: fileData!)
                
                if movies.count > 0 {
                    success(movies)
                } else {
                    failure(.parserError)
                }
            }
        }
    }
    
    func searchMovieByTitle(query: String, success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
        self.moviesConnector.searchMovieByOriginalTitle(query: query, success: { moviesData in
            let movies = self.convertDataIntoModel(data: moviesData)
            success(movies)
        }) { (err) in
            switch err {
            case .internetError:
                failure(.connectionError)
            case .errorInSaveLocalFile:
                failure(.fileError)
            }
        }
    }
    
    func getUpcomingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
        
        self.moviesPersistence.readFile(file: .upcomingMovies) { (fileData, err) in
            if err == .fileNotFound || err == .invalidFileFormat || err == .invalidCache {
                self.moviesConnector.getUpcomingMovies(success: { moviesData in
                    let movies = self.convertDataIntoModel(data: moviesData)
                    if movies.count > 0 {
                        success(movies)
                    } else {
                        failure(.parserError)
                    }
                }, failure: { err in
                    switch err {
                    case .internetError:
                        failure(.connectionError)
                    case .errorInSaveLocalFile:
                        failure(.fileError)
                    }
                })
            } else {
                let movies = self.convertDataIntoModel(data: fileData!)
                
                if movies.count > 0 {
                    success(movies)
                } else {
                    failure(.parserError)
                }
            }
        }
    }
    
    private func convertDataIntoModel(data: Data) -> [Movie] {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! JSON
            
            guard let jsonResult = json["results"] as? [Any]  else {
                return []
            }
            
            var movies: [Movie] = []
            
            for movie in jsonResult {
                guard let movieModel = Movie(json: movie as! JSON) else {
                    break
                }
                
                movies.append(movieModel)
            }

            return movies
            
        } catch {
            print("json error: \(error)")
            return []
        }
    }
    
}
