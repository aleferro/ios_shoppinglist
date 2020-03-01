//
//  SecondViewController.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 16/10/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import UIKit
import SQLite3

/*
 If the Shopping List is empty, the view will display a message to the user.
 Otherwise the shopping list will appear.
 The user can delete an object by right swiping on the cell or can tap on it to edit it.
*/

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var itemsTable: UITableView!
    @IBOutlet weak var hiddenTableLabel: UILabel!
    
    var db: OpaquePointer? = nil
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //var itemsArray:[Shopping] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.itemsTable.backgroundColor = UIColor.clear
        
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully opened connection to database ")
            
            selectQuery()
        }
        else {
            print("Unable to open database")
        }
    }
    
    // Each time navigation to the view happens, the array in the appDelegate get re-written from the database. This is to keep the key values between array and database consistent (new items get an id of -1 when inserted in the array).
    // It also set the background and font colours from the global variables in th Colour class.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colour.sharedIstance.selectedColour
        self.itemsTable.backgroundColor = UIColor.clear
        
        // Fresh start the array to keep it consistent with the database every time.
        appDelegate.itemsArray = []
        
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully opened connection to database ")

            selectQuery()
        }
        else {
            print("Unable to open database")
        }
        
        // If the array is empty display a message to the user instead of the empty list.
        if(appDelegate.itemsArray.count == 0){
            hideStuff()
        }
        
        itemsTable.reloadData()
        
        self.itemsTable.backgroundColor = UIColor.clear
        
        // If the array is not empty, show the shopping list
        if(appDelegate.itemsArray.count != 0){
            showStuff()
        }
    }
    
    // Specify the number of section in the tableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // Specify the number of rows in each section of the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.itemsArray.count
    }
    
    // Define the content of the cells of the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // For Custom Cell
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        let shoppingItem:Shopping = appDelegate.itemsArray[indexPath.row]
        cell.textLabel!.numberOfLines = 2
        cell.detailTextLabel!.numberOfLines = 2
        cell.textLabel!.text = shoppingItem.item + " \nType: " + shoppingItem.group + " Key: " + String(shoppingItem.key)
        cell.detailTextLabel!.text = " Qty: " + String(shoppingItem.qty) + " \nPrice: " + String(Double(shoppingItem.qty) * shoppingItem.price)
        cell.textLabel!.textColor = Colour.sharedFontIstance.selectedFontColour
        cell.detailTextLabel?.textColor = Colour.sharedFontIstance.selectedFontColour
        
        return cell
    }
    
    // Set the specified item as editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    // DELETE - Check if the item has been deleted from the database and delete it from the array as well
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var isDeleteSuccess: Bool
        if editingStyle == .delete {
            var itemToDelete: Shopping = appDelegate.itemsArray[indexPath.row]
            isDeleteSuccess = deleteQuery(itemKey: itemToDelete.key, itemName: itemToDelete.item)
            if(isDeleteSuccess){
                appDelegate.itemsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        }
        if (appDelegate.itemsArray.count == 0){
            hideStuff()
        }
    }
    
    // EDIT - Check if the item has been updated in the database and update its attributes in the array as well.
    // Selecting an item from the tableView triger an AlertBox with fields populated from the selected item. the AlertAction assign the values in the textFields to variables used to update the record in the database. If the update is successfull, the item's attributes in the array are updated as well.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var itemToUpdate = appDelegate.itemsArray[indexPath.row]
        var isUpdateSuccess: Bool = false

        let alertController = UIAlertController (title: "UPDATE", message: "Feel free to update!", preferredStyle:.alert)
        let alertAction = UIAlertAction(title:"Ok", style:.default){(action: UIAlertAction) in
            var itemToUpdateName = alertController.textFields![0].text!
            var itemToUpdatePrice = Double(alertController.textFields![1].text!)!
            var itemToUpdateQty = Int(alertController.textFields![2].text!)!

            isUpdateSuccess = self.updateQuery(id: itemToUpdate.key, itemName: itemToUpdateName, price: itemToUpdatePrice, qty: itemToUpdateQty)

            if (isUpdateSuccess){
                itemToUpdate.item = itemToUpdateName
                itemToUpdate.price = itemToUpdatePrice
                itemToUpdate.qty = itemToUpdateQty
            }

            let indexPath = IndexPath(row: 0, section: 0)
            self.itemsTable.reloadData()
        }

        alertController.addTextField{
            (itemTextField: UITextField) in itemTextField.text = itemToUpdate.item
        }
        alertController.addTextField{
            (priceTextField: UITextField) in priceTextField.text = String(itemToUpdate.price)
        }
        alertController.addTextField{
            (qtyTextField: UITextField) in qtyTextField.text = String(itemToUpdate.qty)
        }

        alertController.addAction(alertAction)
        self.present(alertController, animated:true, completion:nil)
        
    }
    
    // SELECT QUERY - Prepare a select query to be used to populate the list.
    // Retrieve each column in each row in the table and use it to create Shopping objects, then append the objects to the list.
    func selectQuery() {
        let selectQueryStatement = "SELECT * FROM shoppinglist"
        var queryStatement: OpaquePointer? = nil
        if (sqlite3_prepare_v2(db, selectQueryStatement, -1, &queryStatement, nil) == SQLITE_OK) {
            print("Query Result: ")
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let itemKey = Int(sqlite3_column_int(queryStatement, 0))
                let nameField = sqlite3_column_text(queryStatement, 1)
                let itemName = String(cString: nameField!)
                let itemPrice = Double(sqlite3_column_double(queryStatement, 2))
                let groupField = sqlite3_column_text(queryStatement, 3)
                let itemGroup = String(cString: groupField!)
                let itemQty = Int(sqlite3_column_int(queryStatement, 4))
            
                let shoppingItem = Shopping(key: itemKey, item: itemName, group: itemGroup, price: itemPrice, qty: itemQty)
                appDelegate.itemsArray.append(shoppingItem)
            }
        }
        else {
            print("SELECT statement could not be prepared", terminator: "")
        }
        
        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
    }
    
    // DELETE QUERY - Prepare a delete query to be used when removing items from the shopping list. It takes the key as parameter as well as the name as an additional safety measure.
    // AS AN ALTERNATIVE A SOFT DELETE COULD BE IMPLEMENTED, but considering the scope of the application, can be considered redundant.
    func deleteQuery(itemKey:Int, itemName:String) -> Bool {
        let deleteSQL = "DELETE FROM shoppinglist WHERE key = (\(itemKey)) AND item = ('\(itemName)')"
        var isDeleteSuccess: Bool = false
        print(deleteSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully opened connection to database")
            
            if (sqlite3_prepare_v2(db, deleteSQL, -1, &queryStatement, nil) == SQLITE_OK) {
                
                if sqlite3_step(queryStatement) == SQLITE_DONE {
                    print("Record Deleted!")
                    isDeleteSuccess = true
                }
                else {
                    print("Fail to Deleted")
                }
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Delete statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
        }
        return isDeleteSuccess
    }
    
    // UPDATE QUERY - Prepare an update query to be used to update the items on the list. For the sake of simplicity and to allow the use of an AlertBox to execute the update (personal challenge), it doesn't allow to update the group of the item (which by design relies on a set of hard coded values displayed via picklerView).
    func updateQuery(id:Int, itemName:String, price:Double, qty:Int) -> Bool {
        let updateQueryStatement = "UPDATE shoppinglist SET item = '\(itemName)', price = \(price), qty = \(qty) WHERE key = \(id)"
        print(updateQueryStatement)
        var queryStatement: OpaquePointer? = nil
        var isUpdateSuccess: Bool = false
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully opened connection to database  ")
            if (sqlite3_prepare_v2(db, updateQueryStatement, -1, &queryStatement, nil) == SQLITE_OK) {
                if sqlite3_step(queryStatement) == SQLITE_DONE {
                    print("Record Updated!")
                    isUpdateSuccess = true
                }
                else{
                    print("Fail to Insert")
                }
                sqlite3_finalize(queryStatement)
            }
            else {
                print("Insert statement could not be prepared")
            }
            sqlite3_close(db)
        }
        else {
            print("Unable to open database")
        }
        return isUpdateSuccess
    }
    
    // A simple function to hide the tableView and display a message to the user.
    func hideStuff() {
        itemsTable.isHidden = true
        //hiddenTableLabel.frame.origin = CGPoint(x: 105, y: 355)
        hiddenTableLabel!.text! = "There are no items yet!"
        hiddenTableLabel.isHidden = false
    }
    
    // A simple function to show the tableView to the user instead of the message
    func showStuff() {
        hiddenTableLabel.isHidden = true
        itemsTable.isHidden = false
    }
    
}

