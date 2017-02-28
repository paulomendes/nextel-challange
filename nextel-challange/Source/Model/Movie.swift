
import Gloss

class Movie : Decodable {
    let posterPath: String
    let adult: Bool
    let overview: String
    let releaseDate: Date
    let generes: [Int]
    let movieId: Int
    let originalTitle: String
    let voteAvarage: Double
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    required init?(json: JSON) {
        
        guard let posterPath : String = "poster_path" <~~ json else {
            return nil
        }
        
        guard let adult : Bool = "adult" <~~ json else {
            return nil
        }
        
        guard let overview : String = "overview" <~~ json else {
            return nil
        }
        
        guard let releaseDate: Date = Decoder.decode(dateForKey: "release_date", dateFormatter: Movie.dateFormatter)(json) else {
            return nil
        }
        
        guard let generes : [Int] = "genre_ids" <~~ json else {
            return nil
        }
        
        guard let movieId : Int = "id" <~~ json else {
            return nil
        }
        
        guard let originalTitle : String = "original_title" <~~ json else {
            return nil
        }
        
        guard let voteAvarage : Double = "vote_average" <~~ json else {
            return nil
        }
        
        self.posterPath = posterPath
        self.adult = adult
        self.overview = overview
        self.releaseDate = releaseDate
        self.generes = generes
        self.movieId = movieId
        self.originalTitle = originalTitle
        self.voteAvarage = voteAvarage
        
    }
    
}
