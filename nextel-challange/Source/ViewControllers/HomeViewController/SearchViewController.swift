
import UIKit

class SearchViewController: UIViewController, DataAccessObjectProtocol, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    var moviesDAO: MoviesDAO?
    
    var movies: [MovieViewModel] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchController.searchResultsUpdater = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchController.searchBar
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    func setMoviesDAO(moviesDAO: MoviesDAO) {
        self.moviesDAO = moviesDAO
    }
    
    func loadMoviesData() {
        self.movies = []
        let searchString = searchController.searchBar.text!
        
        if searchString.isEmpty {
            self.transformModelsAndReloadData([])
            return
        }
        
        self.moviesDAO?.searchMovieByTitle(query: searchString, success: { (movies) in
            self.transformModelsAndReloadData(movies)
        }, failure: { (err) in
            // handle error here
        })
    }
    
    func filter() {
        self.loadMoviesData()
    }
    
    func transformModelsAndReloadData(_ movies: [Movie]) {
        for movie in movies {
            let movieViewModel = MovieViewModel(movieModel: movie)
            self.movies.append(movieViewModel)
        }
        self.tableView.reloadData()
    }
    
    // MARK: Search Delegate
    
    public func updateSearchResults(for searchController: UISearchController) {
        //Throtlling the Web Request
        SearchViewController.cancelPreviousPerformRequests(withTarget: self,
                                                           selector: #selector(self.filter),
                                                           object: nil)
        self.perform(#selector(self.filter), with: nil, afterDelay: 0.8)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? MovieDetailsViewController {
            destination.movieViewModel = self.movies[sender as! Int]
        }
    }
    
    // MARK: Table View Delegates
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "seach-to-details", sender: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = self.movies[indexPath.row].movieTitle
        return cell
    }
}
