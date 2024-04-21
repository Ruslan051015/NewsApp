import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  // MARK: - Properties:
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "NewsDataModel")
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Ошибка \(error), \(error.userInfo)")
      }
    }
    return container
  }()
  // MARK: - Methods:
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }
}

