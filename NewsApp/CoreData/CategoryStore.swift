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
    let categoryRequest = CategoryCoreDataModel.fetchRequest()
    categoryRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(CategoryCoreDataModel.name), category)
    
    do {
      let existingCategory = try context.fetch(categoryRequest)
      
      if let existingCategory = existingCategory.first {
        let coreDataArticle = ArticleCoreDataModel(context: context)
        coreDataArticle.title = article.title
        coreDataArticle.image = article.image
        coreDataArticle.url = article.url
        coreDataArticle.category = existingCategory
      } else {
        let coreDataCategory = CategoryCoreDataModel(context: context)
        coreDataCategory.name = category
        let coreDataArticle = ArticleCoreDataModel(context: context)
        coreDataArticle.title = article.title
        coreDataArticle.image = article.image
        coreDataArticle.url = article.url
        coreDataArticle.category = coreDataCategory
      }
      saveContext()
    } catch {
      print("Не удалось создать запись в БД")
    }
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
    let request = NSFetchRequest<CategoryCoreDataModel>(entityName: "CategoryCoreDataModel")
    request.returnsObjectsAsFaults = false
    do {
      let categories = try context.fetch(request)
      for category in categories {
        if let articles = category.articles {
          for case let article as ArticleCoreDataModel in articles {
            context.delete(article)
          }
        }
        context.delete(category)
      }
      saveContext()
    } catch {
      print("Ошибка при удалении категорий: \(error)")
    }
  }
  
  // MARK: - Private Methods:
  private func createCategoryModel(from categoryCoreDataModels: [CategoryCoreDataModel]) -> [CategoryModel] {
    var categories: [CategoryModel] = []
    
    for categoryCoreDataModel in categoryCoreDataModels {
      if let categoryName = categoryCoreDataModel.name,
         let articlesSet = categoryCoreDataModel.articles,
         let articleCoreDataModels = articlesSet.allObjects as? [ArticleCoreDataModel] {
        var articles: [ArticleModel] = []
        for articleCoreDataModel in articleCoreDataModels {
          if let title = articleCoreDataModel.title,
             let image = articleCoreDataModel.image,
             let url = articleCoreDataModel.url {
            let articleModel = ArticleModel(title: title, image: image, url: url)
            articles.append(articleModel)
          }
        }
        let categoryModel = CategoryModel(name: categoryName, articles: articles)
        categories.append(categoryModel)
      }
    }
    
    return categories
  }
}
