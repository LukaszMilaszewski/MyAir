import ObjectMapper



class AirCondition: Mappable {
  var date: String?
  var quality: String?

  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    date <- map["stCalcDate"]
    quality <- map["stIndexLevel.indexLevelName"]
  }
}
