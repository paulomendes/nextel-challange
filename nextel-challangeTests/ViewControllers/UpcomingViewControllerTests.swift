
import XCTest
@testable import nextel_challange

class UpcomingViewControllerTests: XCTestCase {
    
    class FauxMoviesDao: MoviesDAOProtocol {
        var upcomingPassed = false
        func getNowPlayingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
            //Silience
        }
        func getUpcomingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
            //Silience
            self.upcomingPassed = true
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
        func searchMovieByTitle(query: String, success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
            //Silience
        }
    }
    
    var systemUnderTest: UpcomingViewController!
    var fauxMoviesDao: FauxMoviesDao!
    
    override func setUp() {
        super.setUp()

        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "UpcomingViewControllerId") as! UpcomingViewController
        fauxMoviesDao = FauxMoviesDao()
        systemUnderTest.setMoviesDAO(moviesDAO: fauxMoviesDao)
        _ = systemUnderTest.view
    }
    
    func testShouldCallMoviesDaoAndParseCorrectly() {
        XCTAssertTrue(fauxMoviesDao.upcomingPassed)
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
