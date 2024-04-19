import UIKit

class NewsViewController: UINavigationController {
// MARK: - Properties:
  
  // MARK: - Private Properties:
  
  // MARK: - LifeCycle:
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    configureNavbar()
  }
}

// MARK: - Private Methods:
extension NewsViewController {
  private func configureNavbar() {
    self.navigationBar.barTintColor = .white
    self.navigationBar.isTranslucent = false
    self.navigationController?.title = "news"
  }
}

// MARK: - Objc-Methods:
extension NewsViewController {
  
}
