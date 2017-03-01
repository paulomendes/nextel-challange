
import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populate(movieViewModel: MovieViewModel) {
        self.posterImageView.kf.setImage(with: movieViewModel.moviePosterImage)
        self.movieTitleLabel.text = movieViewModel.movieTitle
        self.ratingLabel.text = movieViewModel.movieRating
    }

}
