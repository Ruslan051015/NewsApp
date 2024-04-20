import Foundation
import UIKit

final class CustomTableViewCell: UITableViewCell {
  // MARK: - Properties:
  static let reuseID = "CustomUITableViewCell"
  
  // MARK: - Private Properties:
  private var newsModel: NewsModel?
  private lazy var newsCollection: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionNews = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionNews.backgroundColor = .clear
    collectionNews.dataSource = self
    collectionNews.delegate = self
    collectionNews.allowsMultipleSelection = false
    collectionNews.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
    collectionNews.register(CustomUICollectionViewCell.self, forCellWithReuseIdentifier: CustomUICollectionViewCell.reuseID)
    
    return collectionNews
  }()
  
  // MARK: - LifeCycle:
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    setupConstraint()
    self.backgroundColor = .clear
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Methods:
extension CustomTableViewCell {
  func configureCell(with model: NewsModel) {
    self.newsModel = model
    self.newsCollection.reloadData()
  }
}

// MARK: - Private Methods:
extension CustomTableViewCell {
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
extension CustomTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: self.contentView.frame.width / 2.4, height: self.contentView.frame.height)
  }
}

// MARK: - UITableViewDataSource
extension CustomTableViewCell: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomUICollectionViewCell.reuseID, for: indexPath) as? CustomUICollectionViewCell else {
      return UICollectionViewCell()
    }
    guard let newsModel else {
      return UICollectionViewCell()
    }
    cell.configureCell(with: newsModel)
    
    return cell
  }
}
