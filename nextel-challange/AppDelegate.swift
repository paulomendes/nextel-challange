
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let container: Container = Container()
        
        if let tab = window?.rootViewController as? UITabBarController {
            for child in tab.viewControllers ?? [] {
                if let top = child as? DataAccessObjectProtocol {
                    top.setMoviesDAO(moviesDAO: container.resolveMoviesDAO())
                }
            }
        }
        
        return true
    }
}

