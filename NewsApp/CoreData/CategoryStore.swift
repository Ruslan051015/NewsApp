import Foundation
import CoreData
import UIKit

final class CategoryStore: NSObject {
  // MARK: - Properties:
  static let shared = CategoryStore()
  // MARK: - Private Properties:
  private let context: NSManagedObjectContext
  
  // MARK: - LifeCycle:
  convenience override init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Не удалось проинициализировать AppDelegate")
    }
    let context = appDelegate.persistentContainer.viewContext
    self.init(context: context)
  }
  init(context: NSManagedObjectContext) {
    self.context = context
    super.init()
  }
}

extension CategoryStore {
  // MARK: - CoreData Methods:
  func saveContext() {
    if context.hasChanges {
      do {
        try context.save()
        print("Context successfully saved")
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  func createCoreDataArticle(from article: ArticleModel, and category: String) {
    let coreDataCategory = CategoryCoreDataModel(context: context)
    let coreDataArticle = ArticleCoreDataModel(context: context)
    coreDataCategory.name = category
    coreDataArticle.title = article.title
    coreDataArticle.image = article.image
    coreDataArticle.url = article.url
    coreDataArticle.category = coreDataCategory
    
    saveContext()
  }
  
  func fetchCategories() throws -> [CategoryModel] {
    let request = CategoryCoreDataModel.fetchRequest()
    request.returnsObjectsAsFaults = false
    request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    var coreDataCategories: [CategoryCoreDataModel]?
    do {
      coreDataCategories = try context.fetch(request)
    } catch {
      print("Не удалось получить категори")
    }
    
    guard let categories = coreDataCategories else {
      fatalError("Не удалось получить категории")
    }
    let categoryModels = createCategoryModel(from: categories)
    
    return categoryModels
  }
  
  func deleteAllCategories() {
    let request = CategoryCoreDataModel.fetchRequest()
    request.returnsObjectsAsFaults = false
    var coreDataCategories: [CategoryCoreDataModel]?
    do {
      coreDataCategories = try context.fetch(request)
    } catch {
      print("Не удалось получить категори")
    }
    guard let categories = coreDataCategories else {
      fatalError("Не удалось получить категории")
    }
    
    categories.forEach {
      context.delete($0)
    }
    saveContext()
  }
  
  // MARK: - Private Methods:
  private func createCategoryModel(from categoryCoreDataModels: [CategoryCoreDataModel]) -> [CategoryModel] {
    var categories: [CategoryModel] = []
    
    for categoryCoreDataModel in categoryCoreDataModels {
      var articles: [ArticleModel] = []
      
      if let articlesSet = categoryCoreDataModel.articles, let articleCoreDataModels = articlesSet.allObjects as? [ArticleCoreDataModel] {
        for articleCoreDataModel in articleCoreDataModels {
          if let title = articleCoreDataModel.title,
             let image = articleCoreDataModel.image,
             let url = articleCoreDataModel.url {
            let articleModel = ArticleModel(title: title, image: image, url: url)
            articles.append(articleModel)
          }
        }
      }
      
      if let name = categoryCoreDataModel.name {
        let categoryModel = CategoryModel(name: name, articles: articles)
        categories.append(categoryModel)
      }
    }
    
    return categories
  }
  
}
