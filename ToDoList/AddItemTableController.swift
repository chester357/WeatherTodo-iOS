import UIKit

class AddItemTableController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var _tableView: UITableView!
    let _api = ToDoListAPI()
    var _hoursLeft = [NSDate]()
    var _day: Day?
    var _city: String?
    var _zipCode: String?
    var _forcastToday = [WeatherForcast]()
    
    // Transistion Services ======================================================================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch _day! {
        case .Today:
            _api.httpRequest.populateForcast("today", end: "+1day", zipCode: _zipCode!) {
                forcasts in
                self._forcastToday = forcasts
                self._forcastToday.removeLast()
                dispatch_async(dispatch_get_main_queue()){
                    self._tableView.reloadData()
                }
            }
        case .Tomorrow:
            _api.httpRequest.populateForcast("tomorrow", end: "+1day", zipCode: _zipCode!) {
                forcasts in
                self._forcastToday = forcasts
                self._forcastToday.removeLast()
                dispatch_async(dispatch_get_main_queue()){
                    self._tableView.reloadData()
                }
            }
        case .ThreePlus:
            _api.httpRequest.populateForcast("tomorrow", end: "+2day&skip=24", zipCode: _zipCode!) {
                forcasts in
                self._forcastToday = forcasts
                self._forcastToday.removeLast()
                dispatch_async(dispatch_get_main_queue()){
                    self._tableView.reloadData()
                }
            }
        default:
            _hoursLeft = [NSDate]()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var addItemView = (segue.destinationViewController as! AddItemViewController)
        
        if let index = _tableView.indexPathForSelectedRow(){
            addItemView._weatherForcast = _forcastToday[index.row]
            addItemView._city = _city
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = _city
    }
    
    // Table Services ====================================================================================
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _forcastToday.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "'at' hh:mm a"
        
        var dateStr = formatter.stringFromDate(_forcastToday[indexPath.row].Date!)
        switch _day! {
        case .Today:
            dateStr = "Today \(dateStr) "
        case .Tomorrow:
            dateStr = "Tomorrow \(dateStr)"
        case .ThreePlus:
            formatter.dateFormat = "MM-dd 'at' hh:mm a"
            dateStr = formatter.stringFromDate(_forcastToday[indexPath.row].Date!)
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OpenDateCell", forIndexPath: indexPath) as! UITableViewCell
        var aveTemp = _forcastToday[indexPath.row].AveTemp!
        var precInches = _forcastToday[indexPath.row].PrecInches!
        cell.textLabel?.text = "\(dateStr)"
        cell.detailTextLabel?.text = "\(_forcastToday[indexPath.row].DescriptionS!)"
        cell.imageView?.image = UIImage(named: _forcastToday[indexPath.row].Image!)
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(
                red: CGFloat(0.0/255.0), green: CGFloat(102.0/255.0),
                blue: CGFloat(255.0/255.0), alpha: 200.0/225.0)
        } else {
            cell.backgroundColor = UIColor(
                red: CGFloat(48.0/255.0), green: CGFloat(131.0/255.0),
                blue: CGFloat(255.0/255.0), alpha: 255.0/225.0)
        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func unwindFromItemAdded(sender: UIStoryboardSegue){
        
    }

}
