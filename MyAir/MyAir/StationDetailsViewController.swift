import UIKit
import Charts

class StationDetailsViewController: UIViewController {
  
  var station: Station?
  
  override func viewDidLoad() {
    if let station = station {
      title = station.name
    }
  }
}

