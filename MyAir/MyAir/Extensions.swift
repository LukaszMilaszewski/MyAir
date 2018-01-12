import UIKit
import Charts

extension UIColor {
  func qualityColor(name: String) -> UIColor {
    switch name {
    case "Bardzo dobry":
      return UIColor(red: 16/255, green: 142/255, blue: 7/255, alpha: 1)
    case "Dobry":
      return UIColor(red: 15/255, green: 209/255, blue: 2/255, alpha: 1)
    case "Umiarkowany":
      return UIColor(red: 249/255, green: 181/255, blue: 7/255, alpha: 1)
    case "Dostateczny":
      return UIColor(red: 249/255, green: 124/255, blue: 7/255, alpha: 1)
    case "Zły":
      return UIColor(red: 232/255, green: 4/255, blue: 4/255, alpha: 1)
    case "Bardzo zły":
      return UIColor(red: 109/255, green: 2/255, blue: 2/255, alpha: 1)
    default:
      return UIColor.black
    }
  }
  
  func qualityColor(value: Double) -> UIColor {
    switch value {
    case 1:
      return UIColor(red: 109/255, green: 2/255, blue: 2/255, alpha: 1)
    case 2:
      return UIColor(red: 232/255, green: 4/255, blue: 4/255, alpha: 1)
    case 3:
      return UIColor(red: 249/255, green: 124/255, blue: 7/255, alpha: 1)
    case 4:
      return UIColor(red: 249/255, green: 181/255, blue: 7/255, alpha: 1)
    case 5:
      return UIColor(red: 15/255, green: 209/255, blue: 2/255, alpha: 1)
    case 6:
      return UIColor(red: 16/255, green: 142/255, blue: 7/255, alpha: 1)
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
