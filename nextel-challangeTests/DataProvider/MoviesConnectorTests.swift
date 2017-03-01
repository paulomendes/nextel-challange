
import XCTest
import OHHTTPStubs
@testable import nextel_challange

class MoviesError: Error {
    
}

class MoviesConnectorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldCallWithSuccess() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
        stub(condition: isHost("api.themoviedb.org") && isPath("/3/movie/now_playing")) { request in
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
    
    func testShouldCallWithSuccessTheWebService() {
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: UserDefaults.standard)
        let moviesConnector = MoviesConnector(moviesPersistence: moviesPersistence)
        
        let expec = expectation(description: "NowPlayingMovies")
        
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

    
    
}
