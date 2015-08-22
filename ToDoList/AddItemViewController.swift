import UIKit

class AddItemViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var _dateLabel: UILabel!
    @IBOutlet weak var _tempLabel: UILabel!
    @IBOutlet weak var _precipLabel: UILabel!
    @IBOutlet weak var _workItemTitle: UITextField!
    @IBOutlet weak var _windLabel: UILabel!
    @IBOutlet weak var _snowLabel: UILabel!
    @IBOutlet weak var _descriptionLabel: UILabel!
    let _api = ToDoListAPI()
    var _weatherForcast: WeatherForcast?
    var _dateSelected: NSDate?
    var _city: String?
    
    // Transistion Services ======================================================================================

    override func viewDidLoad() {
        super.viewDidLoad()
     }
    
    override func viewWillAppear(animated: Bool) {
        var formatter = NSDateFormatter()
        _dateLabel.text = "\(formatter.stringFromDate(_weatherForcast!.Date!))"
        _tempLabel.text = "\(_weatherForcast!.AveTemp!)°F"
        _precipLabel.text = "\(_weatherForcast!.PrecInches!) inches"
        _snowLabel.text = "\(_weatherForcast!.SnowInches!) inches"
        _windLabel.text = "\(_weatherForcast!.WindSpeed!) mph"
        _descriptionLabel.text = _weatherForcast!.DescriptionL!
        
        view.backgroundColor = UIColor(red: CGFloat(
            48.0/255.0), green: CGFloat(131.0/255.0),
            blue: CGFloat(255.0/255.0), alpha: 255.0/225.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Picker Services =========================================================================================
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var formatter = NSDateFormatter()
        
        formatter.dateFormat = "a"
        var amOrPm = formatter.stringFromDate(_weatherForcast!.Date!)
        
        formatter.dateFormat = "hh"
        var hour = formatter.stringFromDate(_weatherForcast!.Date!)
        
        var minute = ""
        if row <= 9 {
            minute = "0\(row)"
        }
        else {
            minute = "\(row)"
        }
        
        return "\(hour):\(minute) \(amOrPm)"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh"
        var ymdh  = formatter.stringFromDate(_weatherForcast!.Date!)
        
        formatter.dateFormat = "a"
        var amOrPm = formatter.stringFromDate(_weatherForcast!.Date!)
        
        formatter.dateFormat = "mm"
        var minute = ""
        if row <= 9 {
            minute = "0\(row)"
        } else {
            minute = "\(row)"
        }
        
        var dateStr = "\(ymdh):\(minute) \(amOrPm)"
        
        formatter.dateFormat = "yyyy-MM-dd hh:mm a"
        _dateSelected = formatter.dateFromString(dateStr)!
    }
    
    // UI Actions =========================================================================================
    
    @IBAction func textFieldSelected(sender: AnyObject) {
        _workItemTitle.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        var workItem = RWorkItem()
        if let date = _dateSelected {
            workItem = RWorkItem(value: [
                "Id": (_api.dataBase.maxWorkItemId() + 1),
                "Title": _workItemTitle.text,
                "Date": date,
                "WeatherDescription": _weatherForcast!.DescriptionS!,
                "Image": _weatherForcast!.Image!,
                "City": _city!
                ])
        } else {
            workItem = RWorkItem(value: [
                "Id": (_api.dataBase.maxWorkItemId() + 1),
                "Title": _workItemTitle.text,
                "Date": _weatherForcast!.Date!,
                "WeatherDescription": _weatherForcast!.DescriptionS!,
                "Image": _weatherForcast!.Image!,
                "City": _city!
                ])
        }
        
        _api.dataBase.addWorkItem(workItem)
        
        var alertController = UIAlertController(title: "Item Added to List!", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "close", style: UIAlertActionStyle.Default, handler: {
            addAction in
            self.performSegueWithIdentifier("unwindFromItemAdded", sender: self)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
