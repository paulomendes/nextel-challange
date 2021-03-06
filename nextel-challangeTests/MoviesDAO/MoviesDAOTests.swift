
import XCTest
@testable import nextel_challange

class MoviesDAOTests: XCTestCase {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldConvertModelCorrectlyNowPlaying() {
        
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile,success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                let stringResponse = "{\"page\":1,\"results\":[{\"poster_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.posterPath, "/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg")
            XCTAssertFalse(movies.first!.adult)
            XCTAssertEqual(movies.first?.overview, "When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.")
            XCTAssertEqual(movies.first?.releaseDate, MoviesDAOTests.dateFormatter.date(from: "2017-02-08"))
            XCTAssertEqual(movies.first?.originalTitle, "Fifty Shades Darker")
            expec.fulfill()

        }) { err in
            XCTFail()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldConvertModelCorrectlyUpcoming() {
        
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile,success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                let stringResponse = "{\"page\":1,\"results\":[{\"poster_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!)
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.posterPath, "/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg")
            XCTAssertFalse(movies.first!.adult)
            XCTAssertEqual(movies.first?.overview, "When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.")
            XCTAssertEqual(movies.first?.releaseDate, MoviesDAOTests.dateFormatter.date(from: "2017-02-08"))
            XCTAssertEqual(movies.first?.originalTitle, "Fifty Shades Darker")
            expec.fulfill()
            
        }) { err in
            XCTFail()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldConvertModelCorrectlySearch() {
        
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile,success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                let stringResponse = "{\"page\":1,\"results\":[{\"poster_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!)
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.searchMovieByTitle(query: "query", success: { (movies) in
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.posterPath, "/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg")
            XCTAssertFalse(movies.first!.adult)
            XCTAssertEqual(movies.first?.overview, "When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.")
            XCTAssertEqual(movies.first?.releaseDate, MoviesDAOTests.dateFormatter.date(from: "2017-02-08"))
            XCTAssertEqual(movies.first?.originalTitle, "Fifty Shades Darker")
            expec.fulfill()
            
        }) { err in
            XCTFail()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnParseErrorForANotConformJsonNowPlaying() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                let stringResponse = "{\"page\":1,\"results\":[{\"postr_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!)
            }
            
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .parserError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnParseErrorForANotConformJsonUpcoming() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                let stringResponse = "{\"page\":1,\"results\":[{\"postr_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!)
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .parserError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnEmptyArrayForANotConformJsonSearch() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                let stringResponse = "{\"page\":1,\"results\":[{\"postr_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!)
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.searchMovieByTitle(query: "query", success: { (movies) in
            XCTAssertEqual(movies.count, 0)
            expec.fulfill()
        }) { err in
            XCTFail()
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnInternetErrorInCaseOfInternetErrorOnConnectorNowPlaying() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                failure(.internetError)
            }
            
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .connectionError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnInternetErrorInCaseOfInternetErrorOnConnectorUpcoming() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                failure(.internetError)
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .connectionError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnInternetErrorInCaseOfInternetErrorOnConnectorSearch() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                failure(.internetError)
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.searchMovieByTitle(query: "query", success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .connectionError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnFileErrorInCaseConnectorReturnAFileErrorNowPlaying() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                failure(.errorInSaveLocalFile)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .fileError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnFileErrorInCaseConnectorReturnAFileErrorUpcoming() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidCache)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                failure(.errorInSaveLocalFile)
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertEqual(err, .fileError)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWebServiceInCaseOfFileNotFoundNowPlaying() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .fileNotFound)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                self.passed = true
                failure(.internetError)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWebServiceInCaseOfFileNotFoundUpcomming() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .fileNotFound)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                self.passed = true
                failure(.internetError)
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWebServiceInCaseOfInvalidFileFormatNowPlaying() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidFileFormat)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                self.passed = true
                failure(.internetError)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWebServiceInCaseOfInvalidFileFormatNowUpcomming() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidFileFormat)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is Golden
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                self.passed = true
                failure(.internetError)
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is Gloden
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWebServiceInCaseOfInvalidFileFormatSearch() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                success(nil, .invalidFileFormat)
                return
            }
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is Golden
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is Golden
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                self.passed = true
                failure(.internetError)
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        moviesDAO.searchMovieByTitle(query: "query", success: { (movies) in
            XCTFail()
            expec.fulfill()
        }) { err in
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }

    func testShouldConvertCorrectlyLocalFileDiskNowPlaying() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                let stringResponse = "{\"page\":1,\"results\":[{\"poster_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!, .none)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                self.passed = true
                failure(.internetError)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        moviesDAO.getNowPlayingMovies(success: { (movies) in
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.posterPath, "/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg")
            XCTAssertFalse(movies.first!.adult)
            XCTAssertEqual(movies.first?.overview, "When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.")
            XCTAssertEqual(movies.first?.releaseDate, MoviesDAOTests.dateFormatter.date(from: "2017-02-08"))
            XCTAssertEqual(movies.first?.originalTitle, "Fifty Shades Darker")
            expec.fulfill()
        }) { err in
            XCTFail()
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }

    func testShouldConvertCorrectlyLocalFileDiskUpcoming() {
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return true
            }
            
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                let stringResponse = "{\"page\":1,\"results\":[{\"poster_path\":\"/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg\",\"adult\":false,\"overview\":\"When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.\",\"release_date\":\"2017-02-08\",\"genre_ids\":[18,10749],\"id\":341174,\"original_title\":\"Fifty Shades Darker\",\"original_language\":\"en\",\"title\":\"Fifty Shades Darker\",\"backdrop_path\":\"/rXBB8F6XpHAwci2dihBCcixIHrK.jpg\",\"popularity\":189.509821,\"vote_count\":660,\"video\":false,\"vote_average\":6.3}],\"dates\":{\"maximum\":\"2017-03-02\",\"minimum\":\"2017-01-19\"},\"total_pages\":35,\"total_results\":697}"
                success(stringResponse.data(using: .utf8)!, .none)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            
        }
        
        class FauxConnector: MoviesConnectorProtocol {
            var passed = false
            func getNowPlayingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void ) {
                self.passed = true
                failure(.internetError)
            }
            func getUpcomingMovies(success: @escaping (Data) -> Void, failure: @escaping (MoviesConnectorError) -> Void) {
                //Silience is gold
            }
            func searchMovieByOriginalTitle(query: String,
                                            success: @escaping (Data) -> Void,
                                            failure: @escaping (MoviesConnectorError) -> Void ) {
                //Silience is gold
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let connector = FauxConnector()
        let moviesDAO = MoviesDAO(moviesPersistence: moviesPersistence, connector: connector)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        moviesDAO.getUpcomingMovies(success: { (movies) in
            XCTAssertEqual(movies.count, 1)
            XCTAssertEqual(movies.first?.posterPath, "/wnVHDbGz7RvDAHFAsVVT88FxhrP.jpg")
            XCTAssertFalse(movies.first!.adult)
            XCTAssertEqual(movies.first?.overview, "When a wounded Christian Grey tries to entice a cautious Ana Steele back into his life, she demands a new arrangement before she will give him another chance. As the two begin to build trust and find stability, shadowy figures from Christian’s past start to circle the couple, determined to destroy their hopes for a future together.")
            XCTAssertEqual(movies.first?.releaseDate, MoviesDAOTests.dateFormatter.date(from: "2017-02-08"))
            XCTAssertEqual(movies.first?.originalTitle, "Fifty Shades Darker")
            expec.fulfill()
        }) { err in
            XCTFail()
            XCTAssertTrue(connector.passed)
            expec.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
}
