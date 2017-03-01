
import XCTest
@testable import nextel_challange

class SearchViewControllerTests: XCTestCase {

    var systemUnderTest: SearchViewController!
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "SearchViewControllerId") as! SearchViewController
        _ = systemUnderTest.view
    }
    
    func testShouldParseModelsCorrectlyAfterSearch() {
        class FauxMoviesDao: MoviesDAOProtocol {
            func getNowPlayingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
                //Silience
            }
            func getUpcomingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
                //Silience
            }
            func searchMovieByTitle(query: String, success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
                //Silience
                
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
        }
        
        let fauxMoviesDAO = FauxMoviesDao()
        
        systemUnderTest.setMoviesDAO(moviesDAO: fauxMoviesDAO)
        systemUnderTest.searchController.searchBar.text = "Query"
        systemUnderTest.loadMoviesData()
        
        XCTAssertEqual(systemUnderTest.movies.count, 1)
        
        let movieViewModel: MovieViewModel = systemUnderTest.movies.first!
        
        XCTAssertEqual(movieViewModel.movieTitle, "Original Title")
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w185/posterpath.jpg")
        XCTAssertEqual(movieViewModel.moviePosterImage, posterURL)
        XCTAssertEqual(movieViewModel.movieRating, "Rating: 5.0")
        XCTAssertEqual(movieViewModel.movieOverview, "Overview of the Movie")
        XCTAssertEqual(movieViewModel.releaseDate, "February 14, 2017")
    }
    
    func testShouldReturnAnEmptyArrayAndNotCrashIfSearchDontReturnAnyResult() {
        class FauxMoviesDao: MoviesDAOProtocol {
            func getNowPlayingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
                //Silience
            }
            func getUpcomingMovies(success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
                //Silience
            }
            func searchMovieByTitle(query: String, success: @escaping ([Movie]) -> Void, failure: @escaping (MoviesDAOError) -> Void) {
                success([])
            }
        }
        
        let fauxMoviesDAO = FauxMoviesDao()
        
        systemUnderTest.setMoviesDAO(moviesDAO: fauxMoviesDAO)
        systemUnderTest.searchController.searchBar.text = "Query"
        systemUnderTest.loadMoviesData()
        
        XCTAssertEqual(systemUnderTest.movies.count, 0)
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
