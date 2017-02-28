
import UIKit

enum PersistenceErrors {
    case fileNotFound
    case invalidFileFormat
    case invalidCache
    case none
}

protocol Persistence {
    func saveFile(stringJson: String) -> Bool
    func readFile(success: @escaping (Data?, PersistenceErrors) -> Void)
}
