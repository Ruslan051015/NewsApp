import Foundation
import UIKit

struct ResponseModel: Decodable {
  let totalArticles: Int
  let articles: [ArticleModel]
}

struct ArticleModel: Decodable {
  let title: String
  let image: String
  let url: String
}
