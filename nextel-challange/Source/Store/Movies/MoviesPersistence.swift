
import UIKit

enum MovieFile: String {
    case nowPlayingMovies = "now_playing.json"
    case upcomingMovies = "upcoming.json"
}

class MoviesPersistence: Persistence {
    
    static let minutesOfInvalidation: Int = 5
    static let keyForCache = "com.nextel.movies.cache"
    
    let fileManager: FileManager
    let userDefaults: UserDefaults
    
    init(fileManager: FileManager, userDefaults: UserDefaults) {
        self.fileManager = fileManager
        self.userDefaults = userDefaults
    }
    
    func saveFile(stringJson: String, file: MovieFile) -> Bool {
        if let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let filePath = dir.appendingPathComponent(file.rawValue)
            do {
                try stringJson.write(to: filePath, atomically: false, encoding: .utf8)
                self.userDefaults.set(Date(), forKey: MoviesPersistence.keyForCache)
                self.userDefaults.synchronize()
            } catch {
                print("\(error)")
                return false
            }
            return true
        }
        return false
    }
    
    func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void) {
        
        let dateCached: Date = self.userDefaults.value(forKey: MoviesPersistence.keyForCache) as! Date
        
        if Date().minutes(from: dateCached) <= MoviesPersistence.minutesOfInvalidation {
            if let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filePath = dir.appendingPathComponent(file.rawValue)
                do {
                    let contentsOfFile = try Data(contentsOf: filePath, options: .uncached)
                    success(contentsOfFile, .none)
                } catch {
                    success(nil, .invalidFileFormat)
                    return
                }
            }
            success(nil, .fileNotFound)
        } else {
            success(nil, .invalidCache)
        }   
    }
}
