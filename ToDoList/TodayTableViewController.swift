import UIKit
import CoreLocation

class TodayTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    // Global Variables ========================================================================================

    @IBOutlet var _tableView: UITableView!
    @IBOutlet var _activitySpinner: UIActivityIndicatorView!
    @IBOutlet var _indicatorView: UIView!
    let _api = ToDoListAPI()
    let _clLocation = CLLocationManager()
    var _rTodayItems = [RWorkItem]()
    var _city: String?
    var _zipCode: String?

    // Transistion Services ======================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _api.dataBase.initDB()
        
        _activitySpinner.startAnimating()
        _tableView.hidden = true
        _indicatorView.hidden = false
        _indicatorView.backgroundColor = UIColor(
            red: CGFloat(0.0/255.0), green: CGFloat(102.0/255.0),
            blue: CGFloat(255.0/255.0), alpha: 200.0/225.0)
    }
    
    override func viewDidDisappear(animated: Bool) {
        self._clLocation.stopUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        _clLocation.delegate = self
        _clLocation.desiredAccuracy = kCLLocationAccuracyBest
        _clLocation.requestWhenInUseAuthorization()
        _clLocation.startUpdatingLocation()
        
        self.tabBarController?.navigationItem.title = "To-Do List"
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.tabBarController?.navigationItem.rightBarButtonItem = addButton
        
        refreshTable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItem" {
            var addItemContr = (segue.destinationViewController as! AddItemTableController)
            addItemContr._day = Day.Today
            addItemContr._zipCode = _zipCode!
            addItemContr._city = _city!
        }
    }
    
    // Table Services ====================================================================================

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return max(_rTodayItems.count, 7)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "'Today at' hh:mm a"
        
        let cell = tableView.dequeueReusableCellWithIdentifier("WorkItemCell", forIndexPath: indexPath) as! UITableViewCell
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(
                red: CGFloat(0.0/255.0), green: CGFloat(102.0/255.0),
                blue: CGFloat(255.0/255.0), alpha: 200.0/225.0)
        } else {
            cell.backgroundColor = UIColor(
                red: CGFloat(48.0/255.0), green: CGFloat(131.0/255.0),
                blue: CGFloat(255.0/255.0), alpha: 255.0/225.0)
        }
        
        if indexPath.row < _rTodayItems.count {
            var rItem = _rTodayItems[indexPath.row]
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
        if indexPath.row < self._rTodayItems.count {
            var selectedItem = self._rTodayItems[indexPath.row]
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
            self._rTodayItems.removeAll(keepCapacity: false)
            self._rTodayItems = self._api.dataBase.getForToday()
            self._tableView.reloadData()
        }
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
                self._activitySpinner.stopAnimating()
                
                self._indicatorView.hidden = true
                self._tableView.hidden = false
                
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
    
    func insertNewObject(sender: AnyObject) {
        performSegueWithIdentifier("addItem", sender: self)
    }

}
