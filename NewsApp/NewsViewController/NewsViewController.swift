import UIKit

class NewsViewController: UIViewController {
  // MARK: - Private Properties:
  private let newsCategories = [
    "business",
    "entertainment",
    "general",
    "health",
    "nation",
    "science",
    "sports",
    "technology",
    "world"
  ]
  private var news: [String: [ArticleModel]]? = [:]
  private let networkClient = NetworkClient()
  private lazy var newsCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collection.backgroundColor = .clear
    collection.allowsMultipleSelection = false
    collection.dataSource = self
    collection.delegate = self
    collection.register(MainUICollectionViewCell.self, forCellWithReuseIdentifier: MainUICollectionViewCell.reuseID)
    collection.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SupplementaryView.reuseId)
    collection.showsVerticalScrollIndicator = false
    
    return collection
  }()
  
  // MARK: - LifeCycle:
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.background
    configureNavbar()
    setupLayout()
    setupConstraints()
    UIBlockingProgressHUD.show()
    networkClient.fetchNews(for: newsCategories) { [weak self] result in
      guard let self else { return }
      self.news = result
      newsCollection.reloadData()
      UIBlockingProgressHUD.hide()
    }
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
      navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.blackAndWhite]
      navigationController?.navigationBar.standardAppearance = navBarAppearance
      navigationController?.navigationItem.standardAppearance = navBarAppearance
      navigationItem.compactAppearance = navBarAppearance
    }
  }
  
  private func setupLayout() {
    [newsCollection].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
  }
  
  private func setupConstraints() {
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

// MARK: - UICollectionViewDelegateFlowLayout:
extension NewsViewController: UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let news else {
      return 0
    }
    return news.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width, height: 250)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseId, for: indexPath) as? SupplementaryView,
          let news else {
      return UICollectionReusableView()
    }
    let keys = Array(news.keys)
    headerView.titleLabel.text = keys[indexPath.section].capitilizingFirstLetter()
    
    return headerView
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    let indexPath = IndexPath(row: 0, section: section)
    let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
    let headerViewSize = headerView.systemLayoutSizeFitting(
      CGSize(
        width: collectionView.frame.width,
        height: 40),
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .defaultHigh)
    
    return headerViewSize
  }
  
}

// MARK: - UICollectionViewDataSource:
extension NewsViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainUICollectionViewCell.reuseID, for: indexPath) as? MainUICollectionViewCell,
          let news else {
      return UICollectionViewCell()
    }
    let categoryKeys = Array(news.keys)
    let currentSectionCategory = categoryKeys[indexPath.section]
    cell.configureCell(with: news[currentSectionCategory] ?? [])
    
    return cell
  }
}
