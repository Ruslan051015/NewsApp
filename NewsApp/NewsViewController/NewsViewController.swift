import UIKit

class NewsViewController: UIViewController {
// MARK: - Properties:
  
  // MARK: - Private Properties:
  private lazy var newsCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionNews = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionNews.backgroundColor = .clear
    collectionNews.dataSource = self
    collectionNews.delegate = self
    collectionNews.allowsMultipleSelection = false
    
    return collectionNews
  }()
  // MARK: - LifeCycle:
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.background
    configureNavbar()
    configureLayout()
    configureConstraints()
  }
}

// MARK: - Private Methods:
extension NewsViewController {
  private func configureNavbar() {
    if navigationController?.navigationBar != nil {
      self.title = "News"
      let navBarAppearance = UINavigationBarAppearance()
      navBarAppearance.configureWithOpaqueBackground()
      navBarAppearance.backgroundColor = .clear
      navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
      navigationController?.navigationBar.standardAppearance = navBarAppearance
      navigationController?.navigationItem.standardAppearance = navBarAppearance
      navigationItem.compactAppearance = navBarAppearance
    }
  }
  
  private func configureLayout() {
    [newsCollection].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func configureConstraints() {
    NSLayoutConstraint.activate([
      newsCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      newsCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      newsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      newsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
}

// MARK: - Objc-Methods:
extension NewsViewController {
  
}

// MARK: - UICollectionViewDelegate
extension NewsViewController: UICollectionViewDelegate {
  
}

// MARK: - UICollectionViewDataSource
extension NewsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    UICollectionViewCell()
  }
  
  
}
