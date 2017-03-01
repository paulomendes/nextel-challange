
import UIKit

struct DataProvider {
    private static let baseUrl = "https://api.themoviedb.org/3/"
    
    public static let discoverMoviePath = baseUrl + "discover/movie"
    public static let searchMoviePath = baseUrl + "search/movie"
    
    public static let apiKey: String = "ebf9c754b89b6c75ad01c5b985fb5e37"
    
    public static let basePosterUrl = URL(string: "https://image.tmdb.org/t/p/w185")
}
