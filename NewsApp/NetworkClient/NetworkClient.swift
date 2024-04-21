import Foundation
import Alamofire
import UIKit

final class NetworkClient {
  // MARK: - Private Properties:
  private let apiKey = Constants.apiKey
  private let urlString = Constants.baseURLString
  private let urlsession = URLSession.shared
  
  // MARK: - Methods:
  func fetchNews(for categories: [String], completion: @escaping ([String: [ArticleModel]]) -> Void) {
    var newsDictionary = [String: [ArticleModel]]()
    let group = DispatchGroup()
    
    categories.forEach { category in
      group.enter()
      DispatchQueue.global().async { [weak self] in
        guard let self else { return }
        guard let url = URL(string: "\(self.urlString)?category=\(category)&apikey=\(self.apiKey)") else {
          print("Не удалoсь создать URL")
          group.leave()
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
            group.leave()
          }
      }
      group.wait(timeout: .now() + 1.3)
    }
    group.notify(queue: .main) {
      let sortedKeys = newsDictionary.keys.sorted()
      let sortedDictionary = sortedKeys.reduce(into: [String: [ArticleModel]]()) { (result, key) in
        result[key] = newsDictionary[key]
      }
      completion(sortedDictionary)
    }
  }
}
