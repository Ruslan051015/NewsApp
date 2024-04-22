import UIKit

class NewsViewController: UIViewController {
  // MARK: - Properties:
  var isConnectedToNetwork: Bool?
  
  // MARK: - Private Properties:
  private let newsCategories = [
    "business",
    "entertainment",
    "general",
    "health",
//    "nation",
    //    "science",
    //    "sports",
    //    "technology",
    //    "world"
  ]
  private var news: [CategoryModel]? = []
  private var visibleNews: [CategoryModel] = []
  private let networkClient = NetworkClient()
  private let categoryStore = CategoryStore.shared
  private var isSeraching: Bool = false
  private lazy var searchBar: UISearchBar = {
    let bar = UISearchBar()
    bar.delegate = self
    bar.translatesAutoresizingMaskIntoConstraints = false
    bar.placeholder = "Search news"
    bar.backgroundImage = .none
    bar.backgroundColor = .none
    bar.searchTextField.backgroundColor = .lightGray
    bar.searchBarStyle = .minimal
    bar.searchTextField.clearButtonMode = .never
    bar.updateHeight(height: 36)
    
    return bar
  }()
  
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
  
  private lazy var notFoundImageView: UIImageView = {
    let image = UIImage.notFound
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.image = image
    imageView.isHidden = true
    
    return imageView
  }()
  
  // MARK: - LifeCycle:
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.background
    UIBlockingProgressHUD.show()
    configureNavbar()
    setupLayout()
    setupConstraints()
    loadNews()
    setupToHideKeyboardOnTapOnView()
    showOrHideEmptyStub()
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
    [searchBar, newsCollection].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview($0)
    }
    notFoundImageView.translatesAutoresizingMaskIntoConstraints = false
    newsCollection.addSubview(notFoundImageView)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 4),
      searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -4),
      searchBar.heightAnchor.constraint(equalToConstant: 36),
      
      newsCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      newsCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      newsCollection.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 6),
      newsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      notFoundImageView.centerXAnchor.constraint(equalTo: newsCollection.centerXAnchor),
      notFoundImageView.centerYAnchor.constraint(equalTo: newsCollection.centerYAnchor),
      notFoundImageView.heightAnchor.constraint(equalToConstant: 200),
      notFoundImageView.widthAnchor.constraint(equalToConstant: 200)
    ])
  }
  
  private func loadNews() {
    guard let isConnected = isConnectedToNetwork else { return }
    if isConnected {
      categoryStore.deleteAllCategories()
      networkClient.fetchNews(for: newsCategories) { [weak self] result in
        guard let self else { return }
        self.news = result
        self.visibleNews = result
        newsCollection.reloadData()
        for category in result {
          category.articles.forEach { self.categoryStore.createCoreDataArticle(from: $0, and: category.name)
          }
        }
        UIBlockingProgressHUD.hide()
      }
    } else {
      guard let categoies = try? categoryStore.fetchCategories() else { return }
      news = categoies
      visibleNews = categoies
      newsCollection.reloadData()
      UIBlockingProgressHUD.hide()
    }
  }
  
  private func reloadVisibleNews() {
    let textToSearch = (searchBar.searchTextField.text ?? "").lowercased()
    var searchedNews: [CategoryModel] = []
    guard let news else {
      return
    }
    if !textToSearch.isEmpty {
      for category in news {
        let searchedArticles = category.articles.filter { article in
          article.title.lowercased().contains(textToSearch)
        }
        if !searchedArticles.isEmpty {
          searchedNews.append(CategoryModel(name: category.name, articles: searchedArticles))
        }
      }
    }
    if searchedNews.isEmpty && isSeraching == true {
      visibleNews = []
    } else if !searchedNews.isEmpty {
      visibleNews = searchedNews
    } else {
      visibleNews = news
    }
    showOrHideEmptyStub()
    newsCollection.reloadData()
  }
  
  private func showOrHideEmptyStub() {
    notFoundImageView.isHidden = (isSeraching && visibleNews.isEmpty) ? false : true
  }
}

// MARK: - UICollectionViewDelegateFlowLayout:
extension NewsViewController: UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    if isSeraching && visibleNews.isEmpty {
      return 0
    }
    return visibleNews.count
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: collectionView.frame.width, height: 250)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SupplementaryView.reuseId, for: indexPath) as? SupplementaryView,
          let news else {
      return UICollectionReusableView()
    }
    headerView.titleLabel.text = visibleNews[indexPath.section].name.capitilizingFirstLetter()
    
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
          let news,
          indexPath.section < visibleNews.count else {
      return UICollectionViewCell()
    }
    let currentSectionCategory = visibleNews[indexPath.section]
    cell.configureCell(with: currentSectionCategory)
    
    return cell
  }
}

// MARK: - UISearchBarDelegate
extension NewsViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.isEmpty {
      isSeraching = false
    } else {
      isSeraching = true
    }
    reloadVisibleNews()
  }
  
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    guard let text = searchBar.searchTextField.text else {
      return
    }
    isSeraching = text.isEmpty ? false : true
    if text.isEmpty {
      searchBar.showsCancelButton = false
    }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    isSeraching = false
    searchBar.text = nil
    searchBar.showsCancelButton = false
    reloadVisibleNews()
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
    searchBar.showsCancelButton = false
  }
}
