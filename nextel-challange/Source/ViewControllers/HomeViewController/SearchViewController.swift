
import UIKit

class SearchViewController: UIViewController, DataAccessObjectProtocol {

    var moviesDAO: MoviesDAO?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setMoviesDAO(moviesDAO: MoviesDAO) {
        self.moviesDAO = moviesDAO
    }
    
    func loadMoviesData() {
        //Silence
    }
}
