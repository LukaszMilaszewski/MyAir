import UIKit
import AlamofireObjectMapper
import Alamofire
import MapKit
import CoreLocation
import YNDropDownMenu


class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
  
  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  var stations = [Int: Station]()
  
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
            } else {
              // show alert also
            }
            self.stations[station.id!] = station
            self.mapView.addAnnotation(station)
          }
        }
      } else {
        let alertController = UIAlertController(title: "Brak danych", message:
          "Prawdopodobnie serwer z danymi pomiarowymi nie działa. Spróbuj ponownie za chwilę.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Spróbuj ponownie", style: UIAlertActionStyle.default,handler: { action in
          print("ładujeeeeemy")
          self.viewWillAppear(true)
        }))
        
        self.present(alertController, animated: true, completion: nil)
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
  
  @objc func showStationDetails(sender: UIButton) {
    performSegue(withIdentifier: "StationDetails", sender: sender)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "StationDetails" {
      let button = sender as! UIButton
      if let station = stations[button.tag] {
        let controller = segue.destination as! StationDetailsViewController
        controller.station = station
      }
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
    
    guard annotation is Station else {
      return nil
    }
    
    let station = annotation as! Station
    
      let identifier = "station"
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
      if annotationView == nil {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView.isEnabled = true
        pinView.canShowCallout = true
        pinView.animatesDrop = false
        pinView.pinTintColor = pinColor(name: station.condition!.quality!)
        pinView.tintColor = UIColor(white: 0.0, alpha: 0.5)
        
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(self, action: #selector(showStationDetails), for: .touchUpInside)
        pinView.rightCalloutAccessoryView = rightButton
        
        annotationView = pinView
      }
      
      if let annotationView = annotationView {
        annotationView.annotation = annotation
        
        let button = annotationView.rightCalloutAccessoryView as! UIButton
        button.tag = station.id!
      }
      
      return annotationView
  }
}
