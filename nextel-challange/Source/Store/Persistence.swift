
import UIKit

enum PersistenceErrors {
    case fileNotFound
    case invalidFileFormat
    case invalidCache
    case none
}

protocol Persistence {
    func saveFile(stringJson: String, file: MovieFile) -> Bool
    func readFile(file: MovieFile, success: @escaping (Data?, PersistenceErrors) -> Void)
}
