import Foundation

public class HTTPRequestAPI {
    
    private var _dateAPI = DateAPI()
    
    func populateForcast(begin: String, end: String, zipCode: String, handler: (forcasts: [WeatherForcast]) -> ()) {
        var weatherForcasts = [WeatherForcast]()
        
        // Setup HTTP Request
        var url = NSURL(string: "http://api.aerisapi.com/forecasts/\(zipCode)?filter=1hr&from=\(begin)&to=\(end)")
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        var body = "client_id=STxiaTj7jWL6LDQwZVjFN&client_secret=qb5r11NFlruCtAZY9nA8aSTGHBqmqeP9143d0x1Q"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        let queue:NSOperationQueue = NSOperationQueue()
        
        // Make HTTP Request and Handle Response
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var err: NSError?
            
            var json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary
            
            if let parseJSON = json {
                var response = parseJSON["response"] as? NSArray
                var responseFirst = response?.firstObject as? NSDictionary
                var periods = responseFirst?.valueForKey("periods") as! NSArray
                var aveTemps = periods.valueForKey("avgTempF") as! [Int]
                var precInches = periods.valueForKey("precipIN") as! [Double]
                var snowInches = periods.valueForKey("snowIN") as! [Double]
                var windSpeed = periods.valueForKey("windSpeedMPH") as! [Int]
                var descriptionS = periods.valueForKey("weatherPrimary") as! [String]
                var descriptionL = periods.valueForKey("weather") as! [String]
                var image = periods.valueForKey("icon") as! [String]
                var dates = periods.valueForKey("validTime") as! [AnyObject]
                var date = NSDate()
                var dateStr = String()
                var dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-ss:ss"
                
                var startHour = 0
                
                if begin == "today" {
                    startHour = self._dateAPI.getCurrentHour()
                }
                
                for period in startHour..<periods.count {
                    dateStr = dates[period] as! String
                    var date = dateFormatter.dateFromString(dateStr)
                    weatherForcasts.append(WeatherForcast(
                        Date: date,
                        AveTemp: aveTemps[period],
                        PrecInches: precInches[period],
                        DescriptionL: descriptionL[period],
                        DescriptionS: descriptionS[period],
                        Image: image[period],
                        WindSpeed: windSpeed[period],
                        SnowInches: snowInches[period]
                    ))
                }
            }
            
            if(err != nil) {
                println(err!.localizedDescription)
                //let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                //println("Error could not parse JSON: '\(jsonStr)'")
            }
            else {
                if let parseJSON = json {
                    var success = parseJSON["success"] as? Int
                    println("Succes: \(success!)")
                }
                else {
                    let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Error could not parse JSON: \(jsonStr)")
                }
            }

            handler(forcasts: weatherForcasts)
        })
        
    }
}
