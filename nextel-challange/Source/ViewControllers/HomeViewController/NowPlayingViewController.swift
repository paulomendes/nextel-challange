
import UIKit

class NowPlayingViewController: HomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadMoviesData() {
        self.moviesDAO?.getNowPlayingMovies(success: { movies in
            self.transformModelsAndReloadData(movies)
        }, failure: { err in
            self.resolveError(err)
        })
    }

}
