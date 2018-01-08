import ObjectMapper
import MapKit

class Station: NSObject, Mappable, MKAnnotation {
  var id: Int?
  var name: String?
  var coordinate: CLLocationCoordinate2D
  
  required init?(map: Map) {
    coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
  }
  
  func mapping(map: Map) {
    var longitude: Double?
    var latitude: Double?
    
    id <- map["id"]
    name <- map["stationName"]
    longitude <- (map["gegrLon"], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }))
    latitude <- (map["gegrLat"], TransformOf<Double, String>(fromJSON: { Double($0!) }, toJSON: { $0.map { String($0) } }))
    
    coordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
  }
}
