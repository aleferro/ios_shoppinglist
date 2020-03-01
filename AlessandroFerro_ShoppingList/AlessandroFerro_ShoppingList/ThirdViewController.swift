//
//  ThirdViewController.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 16/10/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import UIKit
import SQLite3

/*
 This view allow takes inputs from the user to create a Shopping object and insert it in the database and in the array.
 It also implement some basic validation to check that no values are left blank and that the values are numeric where required.
*/

class ThirdViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var itemTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var qtyTxt: UITextField!
    @IBOutlet weak var groupPickerView: UIPickerView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    
    var itemToAdd: Shopping!
    var groupArray: [String] = ["", "Groceries", "Electronics", "Clothing", "Other"]
    var selectedIndex:Int = 0
    var selectedGroup:String?
    
    // Although already set in the storyboard, as an extra precaution the textFields for price and quantity are set as numeric ones programatically as well.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        priceTxt.keyboardType = .numberPad
        qtyTxt.keyboardType = .numberPad
    }
    
    // The background and font color are set in accordance to the values decided in the settings.
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = Colour.sharedIstance.selectedColour
        itemTxt.textColor = Colour.sharedFontIstance.selectedFontColour
        priceTxt.textColor = Colour.sharedFontIstance.selectedFontColour
        qtyTxt.textColor = Colour.sharedFontIstance.selectedFontColour
        groupPickerView.setValue(Colour.sharedFontIstance.selectedFontColour, forKeyPath: "textColor")
        itemLabel.textColor = Colour.sharedFontIstance.selectedFontColour
        typeLabel.textColor = Colour.sharedFontIstance.selectedFontColour
        priceLabel.textColor = Colour.sharedFontIstance.selectedFontColour
        qtyLabel.textColor = Colour.sharedFontIstance.selectedFontColour
    }
    
    // PICKERVIEW - The set up for the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupArray[row] as String
    }
    
    
    // Assign the value and the index of the row selected by the user to global variables
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        print(groupArray[row])
        
        selectedGroup = groupArray[row]
        
        print(selectedGroup!)
        
        selectedIndex = row
    }
    
    // CLEAR - Clear the textFields to receive new user inputs.
    @IBAction func clearButtonClicked(_ sender: UIButton) {
        itemTxt.text = ""
        priceTxt.text = ""
        qtyTxt.text = ""
    }
    
    // ADD - Check that the new record has been added to the database successfully and create a new Shopping object and append it to the array.
    // The newly created object has a key attribute defaulted at -1 in the database and with an integer value established by the autoincrement in the database. To keep things consistent, each time the list view is called, the list is overwritten with the values from the database.
    @IBAction func addBtnClicked(_ sender: UIButton) {
        var itemName: String?
        var itemPrice: Double?
        var itemQty: Int?
        itemName = itemTxt.text
        itemPrice = Double(priceTxt.text!)
        itemQty = Int(qtyTxt.text!)
        
        var isQuerySuccess: Bool
        
        
        if(checkUserInput()) {
            isQuerySuccess = insertQuery(item: itemName!, price: itemPrice!, group: selectedGroup!, qty: itemQty!)
            
            if(isQuerySuccess) {
                itemToAdd = Shopping(item: itemName!, group: selectedGroup!, price: itemPrice!, qty: itemQty!)
                
                appDelegate.itemsArray.append(itemToAdd)
                
                let alertController = UIAlertController(title: itemName! + " Added", message: "Qty: " + String(itemQty!), preferredStyle:.alert)
                
                // Create action to allow user to close controller
                let alertAction = UIAlertAction(title:"Ok", style: .default, handler:nil)
                
                // Add the action to the controller
                alertController.addAction(alertAction)
                
                // Call the controller
                self.present(alertController, animated:true, completion:nil)
            }
        }
    }
    
    // INSERT QUERY - Prepare an insert query to be used when the add button is clicked.
    func insertQuery(item:String, price:Double, group:String, qty:Int) -> Bool {
        let insertSQL = "INSERT INTO shoppinglist(item, price, 'group', qty) VALUES ('\(item)', \(price), '\(group)', \(qty))"
        print(insertSQL)
        var queryStatement: OpaquePointer? = nil
        var isInsertSuccess:Bool = false
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK {
            print("Successfully opened connection to database  ")
            
            if sqlite3_prepare(db, insertSQL, -1, &queryStatement, nil) == SQLITE_OK {
                if sqlite3_step(queryStatement) == SQLITE_DONE {
                    print("Record Inserted!")
                    isInsertSuccess = true
                }
                else {
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
        return isInsertSuccess
    }
    
    // VALIDATION - Check that no fields are left blank by the user and that price and quantity are boith numeric.
    func checkUserInput() -> Bool {
        
        if((itemTxt.text!.isEmpty) || (priceTxt.text!.isEmpty) || (qtyTxt.text!.isEmpty) || selectedIndex == 0) {

            let alertController = UIAlertController(title: "Beware!", message: "Fields Shall NOT Be Empty!!!", preferredStyle:.alert)

            // Create action to allow user to close controller
            let alertAction = UIAlertAction(title:"Ok, I'm Sorry.", style: .default, handler:nil)

            // Add the action to the controller
            alertController.addAction(alertAction)

            // Call the controller
            self.present(alertController, animated:true, completion:nil)

            return false
        }
        else if
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: priceTxt.text!)) == false || CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: qtyTxt.text!)) == false {
            
            let alertController = UIAlertController(title: "Beware!", message: "Price and Qty should be numbers!!!", preferredStyle:.alert)
            
            // Create action to allow user to close controller
            let alertAction = UIAlertAction(title:"Ok, I'm Sorry.", style: .default, handler:nil)
            
            // Add the action to the controller
            alertController.addAction(alertAction)
            
            // Call the controller
            self.present(alertController, animated:true, completion:nil)
            
            return false
        }
        else {
            itemTxt.text = ""
            priceTxt.text = ""
            qtyTxt.text = ""
            return true
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
