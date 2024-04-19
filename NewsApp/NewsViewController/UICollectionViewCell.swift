import Foundation
import UIKit

final class CustomUICollectionViewCell: UICollectionViewCell {
  // MARK: - Properties:
  static let reuseID = "CustomNewsCell"
  
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
    coverText.font = .boldSystemFont(ofSize: 12)
    coverText.textColor = UIColor.blackAndWhite
    coverText.textAlignment = .center
    coverText.numberOfLines = 11
    coverText.lineBreakMode = .byWordWrapping
    
    return coverText
  }()
  
  // MARK: - LifeCycle
  
}

// MARK: - Methods:
extension CustomUICollectionViewCell {
  
}

// MARK: - Provate Methods:
extension CustomUICollectionViewCell {
  
}
