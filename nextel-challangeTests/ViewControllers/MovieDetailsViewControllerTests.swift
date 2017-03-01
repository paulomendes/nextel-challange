
import XCTest
@testable import nextel_challange

class MovieDetailsViewControllerTests: XCTestCase {
    
    var systemUnderTest: MovieDetailsViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        systemUnderTest = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewControllerId") as! MovieDetailsViewController
        
        let movie: [String : Any] = ["poster_path" : "/posterpath.jpg",
                                     "adult" : false,
                                     "overview" : "Overview of the Movie",
                                     "release_date" : "2017-02-14",
                                     "genre_ids" : [1, 2],
                                     "id" : 123,
                                     "original_title" : "Original Title",
                                     "vote_average" : 5.0]
        let movieModel = Movie(json: movie)!
        let movieViewModel = MovieViewModel(movieModel: movieModel)
        systemUnderTest.movieViewModel = movieViewModel
        _ = systemUnderTest.view
    }
    
    func testShouldLoadCorrectDataOnTheScreen() {
        XCTAssertEqual(systemUnderTest.overviewTextField.text, "Overview of the Movie")
        XCTAssertEqual(systemUnderTest.voteAvarage.text, "Rating: 5.0")
        XCTAssertEqual(systemUnderTest.movieTitle.text, "Original Title")
        XCTAssertEqual(systemUnderTest.releaseDate.text, "February 14, 2017")
        XCTAssertEqual(systemUnderTest.posterImage.kf.webURL?.absoluteString, "https://image.tmdb.org/t/p/w185/posterpath.jpg")
    }
}
