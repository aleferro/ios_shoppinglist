//
//  Colour.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 11/11/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import Foundation
import UIKit

/*
 Contains attributes to be shared by the entire application to set background and font colours.
*/

class Colour {
    static let sharedIstance = Colour()
    static let sharedFontIstance = Colour()
    
    var selectedColour:UIColor? = UIColor.white
    var selectedFontColour: UIColor? = UIColor.black
}
