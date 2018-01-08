import UIKit

class CalloutView: UIView {
    
  @IBOutlet weak var stationName: UILabel!
  @IBOutlet weak var indexLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  
  class func loadNiB() -> CalloutView {
    let calloutView = UINib(nibName: "CalloutView", bundle: nil).instantiate(withOwner: self, options: nil).first as! CalloutView
    return calloutView
  }
}
