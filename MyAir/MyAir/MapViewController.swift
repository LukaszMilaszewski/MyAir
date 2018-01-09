import UIKit
import AlamofireObjectMapper
import Alamofire
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  let locationManager = CLLocationManager()
  
  var stations = [Station]()
  
    @IBAction func getLocation() {
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
    }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    let URL = "http://api.gios.gov.pl/pjp-api/rest/station/findAll"
    request(URL).responseArray { (response: DataResponse<[Station]>) in
      if let data = response.result.value {
        for station in data {
          let URL = "http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/" + String(describing: station.id!)
          request(URL).responseObject { (response: DataResponse<AirCondition>) in
            if let airCondition = response.result.value {
              station.condition = airCondition
            }
            self.stations.append(station)
            self.mapView.addAnnotation(station)
          }
        }
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[0]
    let center = location.coordinate
    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    let region = MKCoordinateRegion(center: center, span: span)

    mapView.setRegion(region, animated: true)
    mapView.showsUserLocation = true
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    let station = view.annotation as! Station
    let views = Bundle.main.loadNibNamed("CalloutView", owner: nil, options: nil)
    let calloutView = views?[0] as! CalloutView
    
    calloutView.stationName.text = station.name!
    calloutView.dateLabel.text = station.condition?.date
    calloutView.indexLabel.text = station.condition?.quality
    
    calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
    view.addSubview(calloutView)
    mapView.setCenter((view.annotation?.coordinate)!, animated: true)
  }
  
  func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
    for subview in view.subviews {
      subview.removeFromSuperview()
    }
  }
  
  func pinColor(name:String) -> UIColor{
    var color = UIColor.black
    switch name {
    case "Bardzo dobry":
      color = UIColor.blue
    case "Dobry":
      color = UIColor.green
    case "Umiarkowany":
      color = UIColor.yellow
    case "Dostateczny":
      color = UIColor.red
    case "Zły":
      color = UIColor.white
    case "Bardzo zły":
      color = UIColor.gray
    
    default:
      color = UIColor.black
    }
    return color
  }
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    var view:MKPinAnnotationView?
    if let station = annotation as? Station {
      view = MKPinAnnotationView(annotation: station, reuseIdentifier: String(describing: station.id))
      view?.pinTintColor = pinColor(name: station.condition!.quality!)
    } else {
      return nil
    }
    return view
  }
}

