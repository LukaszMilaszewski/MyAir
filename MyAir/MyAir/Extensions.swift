import UIKit
import Charts

extension UIColor {
  func qualityColor(name: String) -> UIColor {
    switch name {
    case "Bardzo dobry":
      return UIColor.blue
    case "Dobry":
      return UIColor.green
    case "Umiarkowany":
      return UIColor.yellow
    case "Dostateczny":
      return UIColor.red
    case "Zły":
      return UIColor.white
    case "Bardzo zły":
      return UIColor.gray
    default:
      return UIColor.black
    }
  }
  
  func qualityColor(value: Double) -> UIColor {
    switch value {
    case 1:
      return UIColor.green
    case 2:
      return UIColor.red
    case 3:
      return UIColor.brown
    case 4:
      return UIColor.blue
    case 5:
      return UIColor.yellow
    case 6:
      return UIColor.purple
    default:
      return UIColor.clear
    }
  }
}

extension ChartDataEntry {
  func getColor() -> UIColor {
    return UIColor().qualityColor(value: self.y)
  }
}
