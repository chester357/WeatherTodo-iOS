import Foundation
import RealmSwift

public class DataBaseAPI {
    private var _realm = Realm()
    private var _dateApi = DateAPI()
    
    init () {
        
        setSchemaVersion(0, Realm.defaultPath, {
            migration, oldSchemaVersion in
            if oldSchemaVersion < 0 {
                
            }
        })
        
        println("\(Realm.defaultPath)")
    }
    
    func initDB() {
        
        _realm.beginWrite()
        _realm.deleteAll()
        _realm.commitWrite()
        
        var workItems = getWorkItemList()
        
        _realm.beginWrite()
        for item in workItems {
            _realm.add(item)
        }
        _realm.commitWrite()
    }
    
    func maxWorkItemId() -> Int {
        
        var results = _realm.objects(RWorkItem)
        var max = 0
        for item in results {
            if max < item.Id {
                max = item.Id
            }
        }
        return max
    }
    
    func updateWorkItem(workItem: RWorkItem) {
        _realm.beginWrite()
        println(workItem)
        _realm.add(workItem, update: true)
        _realm.commitWrite()
    }
    
    func updateWorkItemTitle(workItem: RWorkItem, title: String) {
        _realm.beginWrite()
        workItem.Title = title
        _realm.commitWrite()
    }
    
    func deleteWorkItem(workItem: RWorkItem) {
        _realm.beginWrite()
        _realm.delete(workItem)
        _realm.commitWrite()
    }
    
    func addWorkItem(workItem: RWorkItem) {
        _realm.beginWrite()
        _realm.add(workItem)
        _realm.commitWrite()
    }
    
    func clearWorkItems() {
        _realm.beginWrite()
        _realm.delete(_realm.objects(RWorkItem))
        _realm.commitWrite()
    }
    
    func getForToday() -> [RWorkItem] {
        var todayCutOff = _dateApi.addToDate(0.0, minutes: 0.0, hours: 0.0, days: 1.0, date: _dateApi.getTodayStart())
        var items = _realm.objects(RWorkItem)
            .filter("Date < %@ AND Date >= %@", todayCutOff, _dateApi.getTodayStart())
            .sorted("Date", ascending: true)
        var results = [RWorkItem]()
        for item in items {
            results.append(item)
        }
        return results
    }
    
    func getForTomorrow() -> [RWorkItem] {
        var tomorrowCutOff = _dateApi.addToDate(0.0, minutes: 0.0, hours: 0.0, days: 2.0, date: _dateApi.getTodayStart())
        var todayStart = _dateApi.addToDate(0.0, minutes: 0.0, hours: 0.0, days: 1.0, date: _dateApi.getTodayStart())

        var items = _realm.objects(RWorkItem)
            .filter("Date < %@ AND Date >= %@", tomorrowCutOff, todayStart)
            .sorted("Date", ascending: true)
        var results = [RWorkItem]()
        for item in items {
            results.append(item)
        }
        return results
    }
    
    func getForThreePlus() -> [RWorkItem] {
        var thirdDayCutOff = _dateApi.addToDate(0.0, minutes: 0.0, hours: 0.0, days: 3.0, date: _dateApi.getTodayStart())
        var thirdDatStart = _dateApi.addToDate(0.0, minutes: 0.0, hours: 0.0, days: 2.0, date: _dateApi.getTodayStart())
        var items = _realm.objects(RWorkItem)
            .filter("Date < %@ AND Date >= %@", thirdDayCutOff, thirdDatStart)
            .sorted("Date", ascending: true)
        var results = [RWorkItem]()
        for item in items {
            results.append(item)
        }
        return results
    }
    
    func getWorkItemList() -> [RWorkItem] {
        var maxId = _realm.objects(RWorkItem).count
        
        var results = [RWorkItem]()
        
        results.append(RWorkItem( value: [
            "Id": maxId,
            "Title": "Wash Clothes",
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 1.0, days: 0.0),
            "Weather": Weather.Bad.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        results.append(RWorkItem( value: [
            "Title": "Cut the grass",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 2.0, days: 0.0),
            "Weather": Weather.Good.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        results.append(RWorkItem( value: [
            "Title": "Work on project",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 3.0, days: 0.0),
            "Weather": Weather.Bad.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        // Tomorrow
        results.append(RWorkItem( value: [
            "Title": "Work on project",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 0.0, days: 1.0),
            "Weather": Weather.Bad.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        results.append(RWorkItem( value: [
            "Title": "Wash dishes",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 2.0, days: 1.0),
            "Weather": Weather.Bad.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        results.append(RWorkItem( value: [
            "Title": "Fix the roof",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 4.0, days: 1.0),
            "Weather": Weather.Good.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        // 3 +
        results.append(RWorkItem( value: [
            "Title": "Take dog to the Pet Smart",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 2.0, days: 2.0),
            "Weather": Weather.Good.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        results.append(RWorkItem( value: [
            "Title": "Go grocery shopping",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 30.0, hours: 2.0, days: 2.0),
            "Weather": Weather.Good.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        results.append(RWorkItem( value: [
            "Title": "Work on project",
            "Id": ++maxId,
            "Date": _dateApi.addToDay(0.0, minutes: 0.0, hours: 4.0, days: 2.0),
            "Weather": Weather.Bad.rawValue,
            "WeatherDescription":"Fair",
            "Image": "fair",
            "City": "San Francisco"]))
        
        return results
    }
}