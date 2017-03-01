

import XCTest
@testable import nextel_challange

class NowPlayingViewControllerTests: XCTestCase {
    
    class FauxMoviesDao: MoviesDAOProtocol {
        var nowPlaying = false
        func getNowPlayingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
            //Silience
            self.nowPlaying = true
            let movie: [String : Any] = ["poster_path" : "/posterpath.jpg",
                                         "adult" : false,
                                         "overview" : "Overview of the Movie",
                                         "release_date" : "2017-02-14",
                                         "genre_ids" : [1, 2],
                                         "id" : 123,
                                         "original_title" : "Original Title",
                                         "vote_average" : 5.0]
            let movieModel = Movie(json: movie)!
            success([movieModel])
        }
        func getUpcomingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
            //Silience
        }
        func searchMovieByTitle(query: String, success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
            //Silience
        }
    }

    
    var systemUnderTest: NowPlayingViewController!
    var fauxMoviesDao: FauxMoviesDao!
    
    override func setUp() {
        super.setUp()
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "NowPlayingViewControllerId") as! NowPlayingViewController
        fauxMoviesDao = FauxMoviesDao()
        systemUnderTest.setMoviesDAO(moviesDAO: fauxMoviesDao)
        _ = systemUnderTest.view
    }

    func testShouldCallMoviesDaoAndParseCorrectly() {
        XCTAssertTrue(fauxMoviesDao.nowPlaying)
        XCTAssertEqual(systemUnderTest.moviesViewModels.count, 1)
        let movieViewModel: MovieViewModel = systemUnderTest.moviesViewModels.first!
        
        XCTAssertEqual(movieViewModel.movieTitle, "Original Title")
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w185/posterpath.jpg")
        XCTAssertEqual(movieViewModel.moviePosterImage, posterURL)
        XCTAssertEqual(movieViewModel.movieRating, "Rating: 5.0")
        XCTAssertEqual(movieViewModel.movieOverview, "Overview of the Movie")
        XCTAssertEqual(movieViewModel.releaseDate, "February 14, 2017")
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssert(systemUnderTest.conforms(to: UITableViewDataSource.self))
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:numberOfRowsInSection:))))
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:cellForRowAt:))))
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.numberOfSections(in:))))
    }
    
    func testTableViewConformsToTableViewDelegateProtocol() {
        XCTAssert(systemUnderTest.conforms(to: UITableViewDelegate.self))
        XCTAssert(systemUnderTest.responds(to: #selector(systemUnderTest.tableView(_:didSelectRowAt:))))
    }
    
}
