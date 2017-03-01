
import XCTest
@testable import nextel_challange

class MovieViewModelTests: XCTestCase {
    
    func testShouldParseModelToViewModelCorrectly() {
        let movie: [String : Any] = ["poster_path" : "/posterpath.jpg",
                                    "adult" : false,
                                    "overview" : "Overview of the Movie",
                                    "release_date" : "2017-02-14",
                                    "genre_ids" : [1, 2],
                                    "id" : 123,
                                    "original_title" : "Original Title",
                                    "vote_average" : 5.0]
        let movieModel = Movie(json: movie)
        let movieViewModel = MovieViewModel(movieModel: movieModel!)
        
        XCTAssertEqual(movieViewModel.movieTitle, movieModel?.originalTitle)
        let posterURL = URL(string: "https://image.tmdb.org/t/p/w185/posterpath.jpg")
        XCTAssertEqual(movieViewModel.moviePosterImage, posterURL)
        XCTAssertEqual(movieViewModel.movieRating, "Rating: 5.0")
    }
}
