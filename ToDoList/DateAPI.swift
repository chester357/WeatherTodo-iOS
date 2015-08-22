import Foundation

public class DateAPI {
    
    func isGreaterDate(date1: NSDate, date2: NSDate) -> Bool {
        if date1.compare(date2) == NSComparisonResult.OrderedDescending {
            return true
        }
        return false
    }
    
    func isLowerDate(date1: NSDate, date2: NSDate) -> Bool {
        if date1.compare(date2) == NSComparisonResult.OrderedAscending {
            return true
        }
        return false
    }
    
    func addToDate(seconds: Double, minutes: Double, hours: Double, days: Double, date: NSDate) -> NSDate {
        var increase = seconds+60.0*minutes+60*60*hours+24.0*60.0*60.0*days
        return date.dateByAddingTimeInterval(increase)
    }
    
    func getCurrentHour() -> Int {
        return NSCalendar.currentCalendar()
            .components(NSCalendarUnit.CalendarUnitHour, fromDate: NSDate()).hour
    }
    
    func getTodayStart() -> NSDate {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        
        var day = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: NSDate()).day
        var month = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: NSDate()).month
        var year = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: NSDate()).year
        
        var date = formatter.dateFromString("\(year)-\(month)-\(day) at 00:00")
        return date!
    }
    
    func addToDay(seconds: Double, minutes: Double, hours: Double, days: Double) -> NSDate {
        var increase = seconds+60.0*minutes+60*60*hours+24.0*60.0*60.0*days
        return NSDate().dateByAddingTimeInterval(increase)
    }
    
    func hoursLeft() -> [NSDate] {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        
        var hour :Int = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitHour, fromDate: NSDate()).hour
        var day = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitDay, fromDate: NSDate()).day
        var month = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitMonth, fromDate: NSDate()).month
        var year = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear, fromDate: NSDate()).year
        
        var hours = [NSDate]()
        for h in hour...23 {
            var date = formatter.dateFromString("\(year)-\(month)-\(day) at \(h):00")
            hours.append(date!)
        }
        return hours
    }
    
    func tommorowDates() -> [NSDate] {
        var results = [NSDate]()
        var tomorrowStart = addToDate(0.0, minutes: 0.0, hours: 0.0, days: 1.0, date: getTodayStart())
        
        for h in 0...22 {
            var hour = addToDate(0.0, minutes: 0.0, hours: Double(h), days: 0.0, date: tomorrowStart)
            results.append(hour)
        }
        
        return results
    }
    
    func thirdDay() -> [NSDate] {
        var results = [NSDate]()
        var tomorrowStart = addToDate(0.0, minutes: 0.0, hours: 0.0, days: 2.0, date: getTodayStart())
        
        for h in 0...22 {
            var hour = addToDate(0.0, minutes: 0.0, hours: Double(h), days: 0.0, date: tomorrowStart)
            results.append(hour)
        }
        
        return results
    }
}


