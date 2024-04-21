import Foundation

extension String {
  func capitilizingFirstLetter() -> String {
    let first = self.prefix(1).capitalized
    let restString = self.dropFirst()
    
    return first + restString
  }
}
