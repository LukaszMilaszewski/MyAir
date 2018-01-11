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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    obtainAirData()
  }
  
  //MARK: - obtain data
  
  func obtainAirData() {
    let URL = "http://api.gios.gov.pl/pjp-api/rest/station/findAll"
    request(URL).responseArray { (response: DataResponse<[Station]>) in
      if let data = response.result.value {
        for station in data {
          self.obtainAirCondition(station: station)
        }
      } else {
        self.showAlert()
      }
    }
  }
  
  func obtainAirCondition(station: Station) {
    let URL = "http://api.gios.gov.pl/pjp-api/rest/aqindex/getIndex/" + String(describing: station.id!)
    request(URL).responseObject { (response: DataResponse<AirCondition>) in
      if let airCondition = response.result.value {
        station.condition = airCondition
        self.stations[station.id!] = station
        self.mapView.addAnnotation(station)
      }
    }
  }
  
  func showAlert() {
    let alertController = UIAlertController(title: "Brak danych", message:
      "Prawdopodobnie serwer z danymi pomiarowymi nie działa. Spróbuj ponownie za chwilę.", preferredStyle: UIAlertControllerStyle.alert)
    alertController.addAction(UIAlertAction(title: "Spróbuj ponownie", style: UIAlertActionStyle.default,handler: { action in
      self.viewWillAppear(true)
    }))
    
    self.present(alertController, animated: true, completion: nil)
  }
  
  //MARK: - location
  
  @IBAction func getLocation() {
    locationManager.requestAlwaysAuthorization()
    print ("blabla")
    if CLLocationManager.locationServicesEnabled() {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
      locationManager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print("temp")
    if let location = locations.first {
      print("lecimy")
      let center = location.coordinate
      let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
      let region = MKCoordinateRegion(center: center, span: span)
      
      mapView.setRegion(region, animated: true)
      mapView.showsUserLocation = true
      
    }
    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
  
  //MARK: - segue
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "StationDetails" {
      let button = sender as! UIButton
      if let station = stations[button.tag] {
        let controller = segue.destination as! StationDetailsViewController
        controller.station = station
      }
    }
  }
  
  //MARK: - mapView
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is Station else {
      return nil
    }
    
    let station = annotation as! Station
    let identifier = "station"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
    
    if annotationView == nil {
      annotationView = getPinView(annotation: annotation, identifier: identifier, station: station)
    }
    
    if let annotationView = annotationView {
      annotationView.annotation = annotation
      let button = annotationView.rightCalloutAccessoryView as! UIButton
      button.tag = station.id!
    }
    
    return annotationView
  }
  
  func getPinView(annotation: MKAnnotation, identifier: String, station: Station) -> MKPinAnnotationView {
    let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    pinView.isEnabled = true
    pinView.canShowCallout = true
    pinView.animatesDrop = false
    pinView.pinTintColor = UIColor().qualityColor(name: station.condition!.quality!)
    pinView.tintColor = UIColor(white: 0.0, alpha: 0.5)
    
    let rightButton = UIButton(type: .detailDisclosure)
    rightButton.addTarget(self, action: #selector(showStationDetails), for: .touchUpInside)
    pinView.rightCalloutAccessoryView = rightButton
    
    return pinView
  }
  
  @objc func showStationDetails(sender: UIButton) {
    performSegue(withIdentifier: "StationDetails", sender: sender)
  }
}
