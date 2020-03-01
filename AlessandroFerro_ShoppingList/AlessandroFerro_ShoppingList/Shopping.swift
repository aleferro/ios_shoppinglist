//
//  Shopping.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 11/11/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import Foundation

/*
 A Shopping class with three constructors and a toString method.
*/

public class Shopping {
    public var key: Int
    public var item: String
    public var group: String
    public var price: Double
    public var qty: Int
    
    public init() {
        self.key = -1
        self.item = ""
        self.group = ""
        self.price = 0.00
        self.qty = 0
    }
    
    // This constructor allows to create a Shopping object without defining its key attribute so that when a new object is created to be inserted in the database, no key is necessary.
    public init(item:String, group: String, price: Double, qty:Int) {
        self.key = -1
        self.item = item
        self.group = group
        self.price = price
        self.qty = qty
    }
    
    public init(key:Int, item:String, group: String, price: Double, qty:Int) {
        self.key = key
        self.item = item
        self.group = group
        self.price = price
        self.qty = qty
    }
    
    public func toString() -> String {
        return"Key: " + String(self.key) + " Item: " + self.item + " Type: " + self.group + " Price: " + String(self.price) + " Qty: " + String(self.qty)
    }
}
