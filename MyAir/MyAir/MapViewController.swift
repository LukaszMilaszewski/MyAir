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
          print(station.coordinate.latitude)
          print(station.name!)
          self.mapView.addAnnotation(station)
        }
      }
    }
  }
}
