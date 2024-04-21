import Foundation
import Alamofire
import UIKit

final class NetworkClient {
  // MARK: - Private Properties:
  private let apiKey = Constants.apiKey
  private let urlString = Constants.baseURLString
  private let urlsession = URLSession.shared
  
  // MARK: - Methods:
  func fetchNews(for categories: [String]) {
    var newsDictionary = [String: [ArticleModel]]()
    for category in categories {
      DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
        guard let self else { return }
        guard let url = URL(string: "\(self.urlString)?category=\(category)&apikey=\(self.apiKey)") else {
          print("Не удалoсь создать URL")
          return
        }
        AF.request(url, method: .get)
          .validate()
          .responseDecodable(of: ResponseModel.self) { response in
            switch response.result {
            case .success(let data):
              newsDictionary[category] = data.articles
            case .failure(let error):
              print(error.localizedDescription)
            }
          }
      }
    }
  }
}
