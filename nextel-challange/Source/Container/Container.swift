
import UIKit

class Container: NSObject {
    
    
    static let moviesPersistence: MoviesPersistence = {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default,
                                                 userDefaults: UserDefaults.standard)
        return moviesPersistence
    }()
    
    static let moviesConnector: MoviesConnector = {
       let moviesConnector = MoviesConnector(moviesPersistence: Container.moviesPersistence)
        
        return moviesConnector
    }()
    
    
    func resolveMoviesDAO() -> MoviesDAOProtocol {
        return MoviesDAO(moviesPersistence: Container.moviesPersistence, connector: Container.moviesConnector)
    }
    
}
