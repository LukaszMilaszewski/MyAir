import ObjectMapper



class AirCondition: Mappable {
  var date: String?
  var quality: String?
  var so2: String?
  var no2: String?
  var co: String?
  var pm10: String?
  var pm25: String?
  var o3: String?
  var c6h6: String?
  
  required init?(map: Map) { }
  
  func mapping(map: Map) {
    date <- map["stCalcDate"]
    quality <- map["stIndexLevel.indexLevelName"]
    so2 <- map["so2IndexLevel.indexLevelName"]
    no2 <- map["no2IndexLevel.indexLevelName"]
    co <- map["coIndexLevel.indexLevelName"]
    pm10 <- map["pm10IndexLevel.indexLevelName"]
    pm25 <- map["pm25IndexLevel.indexLevelName"]
    o3 <- map["o3IndexLevel.indexLevelName"]
    c6h6 <- map["c6h3IndexLevel.indexLevelName"]
  }
}
