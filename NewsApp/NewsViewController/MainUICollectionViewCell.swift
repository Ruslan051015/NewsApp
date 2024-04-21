import Foundation
import UIKit
import SafariServices

final class MainUICollectionViewCell: UICollectionViewCell {
  // MARK: - Properties:
  static let reuseID = "MainUICollectionViewCell"
  
  // MARK: - Private Properties:
  private var articles: [ArticleModel]? = []
  private lazy var newsCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionNews = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionNews.backgroundColor = .clear
    collectionNews.dataSource = self
    collectionNews.delegate = self
    collectionNews.allowsMultipleSelection = false
    collectionNews.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    collectionNews.register(SecondaryUICollectionViewCell.self, forCellWithReuseIdentifier: SecondaryUICollectionViewCell.reuseID)
    collectionNews.showsHorizontalScrollIndicator = false
    
    return collectionNews
  }()
  
  // MARK: - LifeCycle:
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.backgroundColor = .clear
    setupLayout()
    setupConstraint()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Methods:
extension MainUICollectionViewCell {
  func configureCell(with articles: [ArticleModel]) {
    self.articles = articles
    newsCollection.reloadData()
  }
}

// MARK: - Private Methods:
extension MainUICollectionViewCell {
  private func setupLayout() {
    newsCollection.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(newsCollection)
  }
  
  private func setupConstraint() {
    NSLayoutConstraint.activate([
      newsCollection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      newsCollection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      newsCollection.topAnchor.constraint(equalTo: contentView.topAnchor),
      newsCollection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
  }
}
// MARK: - UITableViewDelegate
extension MainUICollectionViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: self.contentView.frame.width / 2.4, height: self.contentView.frame.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? SecondaryUICollectionViewCell,
    let articleURLString = cell.articleURL,
    let articleURL = URL(string: articleURLString),
    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
    let sceneDelegate = windowScene.delegate as? SceneDelegate,
    let rootViewController = sceneDelegate.window?.rootViewController else {
      return
    }
    let safaviView = SFSafariViewController(url: articleURL)
    rootViewController.present(safaviView, animated: true)
  }
}

// MARK: - UITableViewDataSource
extension MainUICollectionViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let articles {
      return articles.count
    } else {
      return 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SecondaryUICollectionViewCell.reuseID, for: indexPath) as? SecondaryUICollectionViewCell,
          let articles else {
      return UICollectionViewCell()
    }
    
    let article = articles[indexPath.row]
    cell.configureCell(with: article)
    return cell
  }
}
