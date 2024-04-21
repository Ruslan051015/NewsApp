import Foundation
import UIKit

class VerticallyAlignedUILabel: UILabel {
  enum Alignment {
    case top
    case bottom
  }
  
  var alignment: Alignment = .top
  
  override func drawText(in rect: CGRect) {
    var rect = rect
    if alignment == .top {
      rect.size.height = sizeThatFits(rect.size).height
    } else if alignment == .bottom {
      let height = sizeThatFits(rect.size).height
      rect.origin.y += rect.size.height - height
      rect.size.height = height
    }
    super.drawText(in: rect)
  }
}

extension UIImageView {
  
  func makeGradient() {
    let gradient = CAGradientLayer()
    gradient.frame = self.bounds
    gradient.contents = self.image?.cgImage
    gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    gradient.startPoint = CGPoint(x: 0.5, y: 0.5)
    gradient.endPoint = CGPoint(x: 0.5, y: 1)
    self.layer.insertSublayer(gradient, at: 0)
  }
}
