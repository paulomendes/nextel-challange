
import XCTest
@testable import nextel_challange

class MoviesPersistenceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testShouldPassCorrectParametersOnSaveFile() {
        class FauxFileManager : FileManager {
            override func urls(for directory: FileManager.SearchPathDirectory,
                               in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
                XCTAssertEqual(directory, .documentDirectory)
                XCTAssertEqual(domainMask, .userDomainMask)
                return [URL(string: "faux/file/path")!]
            }
        }
        
        let fauxFileManager = FauxFileManager()
        let moviesPersistence = MoviesPersistence(fileManager: fauxFileManager, userDefaults: UserDefaults.standard)
        
        XCTAssertFalse(moviesPersistence.saveFile(stringJson: "faux", file: .upcomingMovies))
    }
    
    func testShouldSaveIntoUserDefaultsTheCacheData() {
        class FauxUserDefaults: UserDefaults {
            override func set(_ value: Any?, forKey defaultName: String) {
                XCTAssertTrue(value is Date)
                XCTAssertEqual(defaultName, MoviesPersistence.keyForCache)
            }
            var didSyncronized = false
            override func synchronize() -> Bool {
                self.didSyncronized = true
                return true
            }
        }
        
        let fauxUserDefaults = FauxUserDefaults()
        
        let moviesPersistence = MoviesPersistence(fileManager: FileManager.default, userDefaults: fauxUserDefaults)
        
        XCTAssertTrue(moviesPersistence.saveFile(stringJson: "faux", file: .upcomingMovies))
        XCTAssertTrue(fauxUserDefaults.didSyncronized)
    }
    
    func testShouldReturnInvalidCacheIfDateStoredIsGreaterThenNow() {
        class FauxFileManager : FileManager {
            var passed = false
            override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
                passed = true
                return[URL(string: "faux/file/path")!]
            }
        }
        
        class FauxUserDefaults : UserDefaults {
            override func value(forKey key: String) -> Any? {
                return Date(timeIntervalSinceNow: -6 * 60)
            }
        }
        
        let fauxFileManager = FauxFileManager()
        let fauxUserDefaults = FauxUserDefaults()
        let moviesPersistence = MoviesPersistence(fileManager: fauxFileManager, userDefaults: fauxUserDefaults)
        
        let ex = expectation(description: "MoviesPersistence")
        
        moviesPersistence.readFile(file: .upcomingMovies) { (movieData, err) in
            XCTAssertEqual(err, .invalidCache)
            ex.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { err in
            XCTAssertFalse(fauxFileManager.passed)
        }
    }
    
    func testShoulOpenFileIfCachedDataIsLessThenNow() {
        class FauxFileManager : FileManager {
            var passed = false
            override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
                passed = true
                return[URL(string: "faux/file/path")!]
            }
        }
        
        class FauxUserDefaults : UserDefaults {
            override func value(forKey key: String) -> Any? {
                return Date(timeIntervalSinceNow: 3 * 60)
            }
        }
        
        let fauxFileManager = FauxFileManager()
        let fauxUserDefaults = FauxUserDefaults()
        let moviesPersistence = MoviesPersistence(fileManager: fauxFileManager, userDefaults: fauxUserDefaults)
        
        let ex = expectation(description: "MoviesPersistence")
        
        moviesPersistence.readFile(file: .upcomingMovies) { (movieData, err) in
            ex.fulfill()
        }
        
        self.waitForExpectations(timeout: 5) { err in
            XCTAssertTrue(fauxFileManager.passed)
        }
    }
}
