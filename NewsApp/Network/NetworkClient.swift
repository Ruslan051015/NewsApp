import Foundation
import Alamofire
import UIKit

final class NetworkClient {
  // MARK: - Private Properties:
  private let apiKey = Constants.apiKey
  private let urlString = Constants.baseURLString
  private let urlsession = URLSession.shared
  
  // MARK: - Methods:
  func fetchNews(for categories: [String], completion: @escaping ([CategoryModel]) -> Void) {
    var categoriesArray = [CategoryModel]()
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
              let category = CategoryModel(name: category, articles: data.articles)
              categoriesArray.append(category)
            case .failure(let error):
              print(error.localizedDescription)
            }
            group.leave()
          }
      }
      group.wait(timeout: .now() + 1.3)
    }
    group.notify(queue: .main) {
      let sortedArray = categoriesArray.sorted { $0.name < $1.name  }
      completion(sortedArray)
    }
  }
}

