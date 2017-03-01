
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataAccessObjectProtocol {
    
    var moviesDAO: MoviesDAOProtocol?
    var moviesViewModels: [MovieViewModel] =  []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMoviesData()
    }
    
    func setMoviesDAO(moviesDAO: MoviesDAO) {
        self.moviesDAO = moviesDAO
    }
    
    func loadMoviesData() {
        preconditionFailure("This function should be overriden")
    }
    
    internal func resolveError(_ err:MoviesDAOError) {
        switch err {
        case .fileError:
            self.showAlertError(message: "Erro ao tentar ler o arquivo. Tente novamente")
        case .connectionError:
            self.showAlertError(message: "Houve um erro na sua conexão com a internet. Tente novamente")
        case .parserError:
            self.showAlertError(message: "Erro ao parsear objeto")
        }
    }
    
    func transformModelsAndReloadData(_ movies: [Movie]) {
        for movie in movies {
            let movieViewModel = MovieViewModel(movieModel: movie)
            self.moviesViewModels.append(movieViewModel)
        }
        self.tableView.reloadData()
    }
    
    internal func showAlertError(message: String) {
        let alert: UIAlertController = UIAlertController(title: "Erro",
                                                         message: message,
                                                         preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Table View Delegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "home-cell",
                                                                               for: indexPath) as! HomeTableViewCell
        cell.populate(movieViewModel: self.moviesViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.moviesViewModels.count
    }
    
}
