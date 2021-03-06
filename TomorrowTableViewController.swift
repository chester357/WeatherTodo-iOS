import UIKit
import CoreLocation

class TomorrowTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    // Global Variables ========================================================================================
    
    @IBOutlet weak var _tableView: UITableView!
    let _clLocation = CLLocationManager()
    let _api = ToDoListAPI()
    var _tomorrowItems = [RWorkItem]()
    var _city: String?
    var _zipCode: String?
    var _forcasts = [WeatherForcast]()
    
    // Transistion Services ======================================================================================

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        _clLocation.delegate = self
        _clLocation.desiredAccuracy = kCLLocationAccuracyBest
        _clLocation.requestWhenInUseAuthorization()
        _clLocation.startUpdatingLocation()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.tabBarController?.navigationItem.title = "To-Do List"
        self.tabBarController?.navigationItem.rightBarButtonItem = addButton
        
        refreshTable()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self._clLocation.stopUpdatingLocation()
    }
    
    func insertNewObject(sender: AnyObject) {
        performSegueWithIdentifier("addItem", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItem" {
            var destination = (segue.destinationViewController as! AddItemTableController)
            destination._day = Day.Tomorrow
            destination._zipCode = _zipCode!
            destination._city = _city!
        }
    }
    
    // Table Services ====================================================================================

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(_tomorrowItems.count, 7)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        var formatter = NSDateFormatter()
        formatter.dateFormat = "'Tomorrow at' hh:mm a"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: CGFloat(0.0/255.0), green: CGFloat(102.0/255.0), blue: CGFloat(255.0/255.0), alpha: 200.0/225.0)
        } else {
            cell.backgroundColor = UIColor(red: CGFloat(48.0/255.0), green: CGFloat(131.0/255.0), blue: CGFloat(255.0/255.0), alpha: 255.0/225.0)
        }
        
        if indexPath.row < _tomorrowItems.count {
            var rItem = _tomorrowItems[indexPath.row]
            var rDate = formatter.stringFromDate(rItem.Date)
            
            cell.detailTextLabel!.text = "\(rDate) \n\(rItem.City) \nWeather is \(rItem.WeatherDescription)"
            cell.textLabel!.text = "\(rItem.Title)"
            cell.imageView!.image = UIImage(named: rItem.Image)
            
            return cell
        }
        else {
            cell.detailTextLabel!.text =  " "
            cell.textLabel!.text = " "
            cell.imageView!.image = nil
            return cell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        if indexPath.row < self._tomorrowItems.count {
            var selectedItem = self._tomorrowItems[indexPath.row]
            var results = _api.viewService.getTableActions(selectedItem, view: self, callback: {
                self.refreshTable()
            })
            return results.actions
        } else {
            return nil
        }
    }
    
    func refreshTable() {
        dispatch_async(dispatch_get_main_queue()){
            self._tomorrowItems.removeAll(keepCapacity: false)
            self._tomorrowItems = self._api.dataBase.getForTomorrow()
            self._tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Location Services ====================================================================================
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {
            (placemarks, error) -> Void in
            
            if error != nil {
                println("Error: " + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                if self._city != pm.locality || self._zipCode != pm.postalCode {
                    self._city = pm.locality
                    self._zipCode = pm.postalCode
                    self.refreshTable()
                }
            }
        });
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
}
