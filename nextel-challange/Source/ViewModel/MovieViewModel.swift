
import UIKit
import Kingfisher

class MovieViewModel: NSObject {
    let moviePosterImage: URL?
    let movieTitle: String?
    let movieRating: String?
    let movieOverview: String?
    let releaseDate: String?
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    init(movieModel: Movie) {
        self.moviePosterImage = DataProvider.basePosterUrl?.appendingPathComponent(movieModel.posterPath)
        self.movieTitle = movieModel.originalTitle
        self.movieRating = "Rating: \(movieModel.voteAvarage)"
        self.releaseDate = MovieViewModel.formatter.string(from: movieModel.releaseDate)
        self.movieOverview = movieModel.overview
    }
}
