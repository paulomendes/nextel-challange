
import UIKit

class MovieDetailsViewController: UIViewController {

    var movieViewModel: MovieViewModel?
    
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var overviewTextField: UITextView!
    @IBOutlet weak var voteAvarage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.movieTitle.text = self.movieViewModel?.movieTitle
        self.posterImage.kf.setImage(with: self.movieViewModel?.moviePosterImage)
        self.overviewTextField.text = self.movieViewModel?.movieOverview
        self.voteAvarage.text = self.movieViewModel?.movieRating
        self.releaseDate.text = self.movieViewModel?.releaseDate
    }

    @IBAction func didTapCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
