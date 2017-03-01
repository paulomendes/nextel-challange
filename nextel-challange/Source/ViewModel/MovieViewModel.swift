
import UIKit
import Kingfisher

class MovieViewModel: NSObject {
    let moviePosterImage: URL?
    let movieTitle: String?
    let movieRating: String?
    
    init(movieModel: Movie) {
        self.moviePosterImage = DataProvider.basePosterUrl?.appendingPathComponent(movieModel.posterPath)
        self.movieTitle = movieModel.originalTitle
        self.movieRating = "Rating: \(movieModel.voteAvarage)"
    }
}
