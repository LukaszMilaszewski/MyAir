import UIKit
import AlamofireObjectMapper
import Alamofire
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  override func viewDidLoad() {
    let URL = "http://api.gios.gov.pl/pjp-api/rest/station/findAll"
    request(URL).responseArray { (response: DataResponse<[Station]>) in
      if let stations = response.result.value {
        for station in stations {
          self.mapView.addAnnotation(station)
        }
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let station = view.annotation as! Station
    let views = Bundle.main.loadNibNamed("CalloutView", owner: nil, options: nil)
    let calloutView = views?[0] as! CalloutView
    
    calloutView.stationName.text = station.name!
    
    let URL = "http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/" + String(describing: station.id!)
    request(URL).responseObject { (response: DataResponse<AirCondition>) in
      let airCondition = response.result.value
      calloutView.dateLabel.text = airCondition?.date
      calloutView.indexLabel.text = airCondition?.quality
    }
    
    calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
    view.addSubview(calloutView)
    mapView.setCenter((view.annotation?.coordinate)!, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    for subview in view.subviews {
      subview.removeFromSuperview()
    }
  }
}
