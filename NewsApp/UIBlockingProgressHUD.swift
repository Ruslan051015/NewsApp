import Foundation
import ProgressHUD
import UIKit

// Класс для блокировки UI на время выполнения запроса в сеть и индикации, что запрос выполняется
final class UIBlockingProgressHUD {
  // MARK: - Private Properties:
  private static var window: UIWindow? {
      if #available(iOS 13.0, *) {
          if let windowScene = UIApplication.shared.connectedScenes
              .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
              return windowScene.windows.first
          }
      } else {
          return UIApplication.shared.keyWindow
      }
      return nil
  }


  static func show() {
    window?.isUserInteractionEnabled = false
    ProgressHUD.animate()
    ProgressHUD.animationType = .activityIndicator
    ProgressHUD.colorAnimation = .black
    ProgressHUD.colorStatus = .black
    ProgressHUD.mediaSize = 30
    ProgressHUD.marginSize = 30
  }
  
  static func hide() {
    window?.isUserInteractionEnabled = true
    ProgressHUD.dismiss()
  }
}
