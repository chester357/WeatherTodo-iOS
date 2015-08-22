import Foundation
import RealmSwift

class RWorkItem: Object {
    
    dynamic var Id = 0
    dynamic var Title = ""
    dynamic var Complete = false
    dynamic var Date = NSDate()
    dynamic var Weather = 0
    dynamic var WeatherDescription = ""
    dynamic var Image = ""
    dynamic var City = ""
    
    override static func primaryKey() -> String {
        return "Id"
    }
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
