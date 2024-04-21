import Foundation
import UIKit
import Kingfisher

final class SecondaryUICollectionViewCell: UICollectionViewCell {
  // MARK: - Properties:
  static let reuseID = "SecondaryUICollectionViewCell"
  var articleURL: String?
  
  // MARK: - Private Properties:
  private lazy var newsImageView: UIImageView = {
    let cover = UIImageView()
    cover.contentMode = .scaleAspectFill
    cover.layer.masksToBounds = true
    cover.layer.cornerRadius = 12
    
    return cover
  }()
  
  private lazy var newsLabel: UILabel = {
    let coverText = UILabel()
    coverText.font = .systemFont(ofSize: 16, weight: .heavy)
    coverText.textColor = UIColor.white
    coverText.textAlignment = .right
    coverText.numberOfLines = 11
    
    return coverText
  }()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    newsLabel.text = ""
    newsImageView.image = nil
    articleURL = nil
  }
}

// MARK: - Methods:
extension SecondaryUICollectionViewCell {
  func configureCell(with article:ArticleModel) {
    newsLabel.text = article.title
    let url = article.image
    let imageToURL = URL(string: article.image)
    newsImageView.kf.indicatorType = .activity
    newsImageView.kf.setImage(with: imageToURL, placeholder: UIImage.placeholder, options: [.transition(.fade(1))])
    self.articleURL = article.url
  }
}

// MARK: - Provate Methods:
extension SecondaryUICollectionViewCell {
  private func setupLayout() {
    newsImageView.translatesAutoresizingMaskIntoConstraints = false
    newsLabel.translatesAutoresizingMaskIntoConstraints = false
    newsImageView.addSubview(newsLabel)
    contentView.addSubview(newsImageView)
    
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      newsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
      newsImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      
      newsLabel.leadingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: 16),
      newsLabel.trailingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: -16),
      newsLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor, constant: 16),
      newsLabel.bottomAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: -16)
    ])
  }
}
