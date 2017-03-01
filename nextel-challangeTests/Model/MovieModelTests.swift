
import XCTest
@testable import nextel_challange

class MovieModelTests: XCTestCase {
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    func testShouldParseModelCorrectly() {
        let movie: [String : Any] = ["poster_path" : "/posterpath.jpg",
                                     "adult" : false,
                                     "overview" : "Overview of the Movie",
                                     "release_date" : "2017-02-14",
                                     "genre_ids" : [1, 2],
                                     "id" : 123,
                                     "original_title" : "Original Title",
                                     "vote_average" : 5.0]
        let movieModel = Movie(json: movie)!
        
        XCTAssertFalse(movieModel.adult)
        XCTAssertEqual(movieModel.posterPath, "/posterpath.jpg")
        XCTAssertEqual(movieModel.overview, "Overview of the Movie")
        XCTAssertEqual(movieModel.releaseDate, MovieModelTests.dateFormatter.date(from: "2017-02-14"))
        XCTAssertEqual(movieModel.generes, [1, 2])
        XCTAssertEqual(movieModel.originalTitle, "Original Title")
        XCTAssertEqual(movieModel.voteAvarage, 5.0)
        
    }
    
}
