import UIKit
import CoreData
import Reachability

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  // MARK: - Properties:
  var isConnectedToNetwork: Bool?
  
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
    setupReachability()
    return true
  }
  
  private func setupReachability() {
    do {
      let reachability = try Reachability()
      switch reachability.connection {
      case .cellular, .wifi:
        isConnectedToNetwork = true
      case .unavailable:
        isConnectedToNetwork = false
      }
    } catch {
      print("Не удалось проверить соединение")
    }
  }
}

