import Foundation
import UIKit

public class ViewAPI {
    var _dataBaseAPI = DataBaseAPI()
    
    func getTableActions(selectedItem: RWorkItem, view: UIViewController,
        callback: () -> Void) -> (actions: [UITableViewRowAction], alert: UIAlertController) {
            
            var actions = [UITableViewRowAction]()
            var alert = UIAlertController()
        
            var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "   Edit     ") {
                (action, path) in
                alert = UIAlertController(title: "Edit Item", message: selectedItem.Title, preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler{
                    textfield in
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil ))
                    alert.addAction(UIAlertAction(title: "Submit", style: UIAlertActionStyle.Destructive, handler: {
                        submitAlert in
                        var newTitle = textfield.text
                        self._dataBaseAPI.updateWorkItemTitle(selectedItem, title: newTitle)
                        callback()
                    }))
                }
                view.presentViewController(alert, animated: true, completion: nil)
            }
            editAction.backgroundColor = UIColor(red: 102/255, green: 0/255, blue: 255/255, alpha: 1)
            actions.append(editAction)
            
            var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "  Delete  "){
                (action, path) in
                self._dataBaseAPI.deleteWorkItem(selectedItem)
                callback()
            }
            actions.append(deleteAction)
            
            return (actions, alert)
    }
}
