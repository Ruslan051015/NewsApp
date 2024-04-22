import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = scene as? UIWindowScene,
    let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let isConnectedToNetwork = appDelegate.isConnectedToNetwork
    let window = UIWindow(windowScene: scene)
    let newsController = NewsViewController()
    newsController.isConnectedToNetwork = isConnectedToNetwork
    let rootViewController = UINavigationController(rootViewController: newsController)
    window.rootViewController = rootViewController
    self.window = window
    self.window?.makeKeyAndVisible()
  }
}

