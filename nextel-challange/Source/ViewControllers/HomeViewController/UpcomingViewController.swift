
import UIKit

class UpcomingViewController: HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadMoviesData() {
        self.moviesDAO?.getUpcomingMovies(success: { movies in
            self.transformModelsAndReloadData(movies)
        }, failure: { err in
            self.resolveError(err)
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "upcoming-to-details", sender: indexPath.row)
    }
}
