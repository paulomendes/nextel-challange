
import XCTest
import OHHTTPStubs
@testable import nextel_challange

class MoviesError: Error {
    
}

class MoviesConnectorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldReturnInternetErrorInCaseOfNot200ResponsNowPlaying() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 500,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.getNowPlayingMovies(success: { movies in
            print(movies)
            expec.fulfill()
            XCTFail()
        }, failure: { err in
            XCTAssertEqual(err, .internetError)
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnInternetErrorInCaseOfNot200ResponsUpcoming() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 500,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.getUpcomingMovies(success: { movies in
            print(movies)
            expec.fulfill()
            XCTFail()
        }, failure: { err in
            XCTAssertEqual(err, .internetError)
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnInternetErrorInCaseOfNot200ResponsSearch() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/search/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 500,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.searchMovieByOriginalTitle(query: "teste", success: { movies in
            print(movies)
            expec.fulfill()
            XCTFail()
        }, failure: { err in
            XCTAssertEqual(err, .internetError)
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWithSuccessNowPlaying() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.getNowPlayingMovies(success: { movies in
            print(movies)
            expec.fulfill()
        }, failure: { err in
            XCTFail()
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWithSuccessTheWebServiceGetUpComming() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.getUpcomingMovies(success: { movies in
            print(movies)
            expec.fulfill()
        }, failure: { err in
            XCTFail()
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldCallWithSuccessTheWebServiceSearch() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/search/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.searchMovieByOriginalTitle(query:"test", success: { movies in
            print(movies)
            expec.fulfill()
        }, failure: { err in
            XCTFail()
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnInternetErrorInCaseOfANot200statusSearch() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/search/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 500,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.searchMovieByOriginalTitle(query:"test", success: { movies in
            print(movies)
            expec.fulfill()
            XCTFail()
        }, failure: { err in
            XCTAssertEqual(err, .internetError)
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    
    func testShouldReturnErrorOfParseInCaseOfTheSaveFileErrorNowPlaying() {
        
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return false
            }
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                //Silience is golden
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.getNowPlayingMovies(success: { movies in
            XCTFail()
            expec.fulfill()
        }, failure: { err in
            XCTAssertEqual(err, .errorInSaveLocalFile)
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    func testShouldReturnErrorOfParseInCaseOfTheSaveFileErrorUpcommingMovies() {
        
        class FauxMoviesPersistence: Persistence {
            func saveFile(stringJson: String, file: MovieFile) -> Bool {
                return false
            }
            func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
                //Silience is golden
            }
        }
        
        let moviesPersistence = FauxMoviesPersistence()
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/discover/movie")) { request in
            guard let file = OHPathForFile("now_playing.json", MoviesConnectorTests.self) else {
                XCTFail()
                return OHHTTPStubsResponse(error: MoviesError())
            }
            
            return OHHTTPStubsResponse(fileAtPath: file,
                                       statusCode: 200,
                                       headers: [ "Content-Type": "application/json" ])
        }
        
        moviesConnector.getUpcomingMovies(success: { movies in
            XCTFail()
            expec.fulfill()
        }, failure: { err in
            XCTAssertEqual(err, .errorInSaveLocalFile)
            expec.fulfill()
        })
        
        self.waitForExpectations(timeout: 5) { (err) in
            XCTAssertNil(err, "Something gone wrong")
        }
    }
    
    
}
