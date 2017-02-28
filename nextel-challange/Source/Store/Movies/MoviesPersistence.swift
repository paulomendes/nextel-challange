
import UIKit

class MoviesPersistence: Persistence {
    
    static let moviesFile: String = "movies.json"
    static let minutesOfInvalidation: Int = 5
    static let keyForCache = "com.nextel.movies.cache"
    
    let fileManager: FileManager
    let userDefaults: UserDefaults
    
    init(fileManager: FileManager, userDefaults: UserDefaults) {
        self.fileManager = fileManager
        self.userDefaults = userDefaults
    }
    
    func saveFile(stringJson: String) -> Bool {
        if let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let filePath = dir.appendingPathComponent(MoviesPersistence.moviesFile)
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
    
    func readFile(success: @escaping (Data?, PersistenceErrors) -> Void) {
        
        let dateCached: Date = self.userDefaults.value(forKey: MoviesPersistence.keyForCache) as! Date
        
        if Date().minutes(from: dateCached) <= MoviesPersistence.minutesOfInvalidation {
            if let dir = self.fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                let filePath = dir.appendingPathComponent(MoviesPersistence.moviesFile)
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
