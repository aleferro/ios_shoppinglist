//
//  Item.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 16/10/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import Foundation

public class Shopping {
    
    public var item: String
    public var price: Double
    public var group: String
    public var qty: Int
    
    public init() {
        self.item = ""
        self.price = 0
        self.group = ""
        self.qty = 0
        self.isMarked = false
    }
    
    public init(name:String, price: Double , group: String, qty:Int) {
        self.item = item
        self.price = price
        self.group = group
        self.qty = qty
    }
    
    public func toString() -> String {
        return "Item: " + self.name + "Price: " + self.price + " Group: " + self.group + " qty: " + String(self.qty)
    }
}
