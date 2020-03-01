//
//  FourthViewController.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 6/11/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import UIKit

/*
 Allow the user to change the colour of some components throughout the app.
 It also allow the user to reset the original values in case he/she mess up.
*/

class FourthViewController: UIViewController {

    @IBOutlet weak var selectedColourView: UIView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var fontColourTxt: UILabel!
    @IBOutlet weak var bgLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // By moving the slider changes colour of the view.
    @IBAction func sliderChanged(_ sender: Any) {
        selectedColourView.backgroundColor = uiColorFromHex(rgbValue: colorArray[Int(slider.value)])
    }
    
    // By moving the slider changes the colour of the dummy text.
    @IBAction func fontSliderChanged(_ sender: Any) {
        fontColourTxt.textColor = uiColorFromHex(rgbValue: colorArray[Int(fontSlider.value)])
    }
    
    // Set the colours chosen in the two sliders as the values of the global variables for the background and the font colours in the Colour class.
    // It also set the background and the font colours of the view as the global colour.
    @IBAction func confirmClicked(_ sender: UIButton) {
        
        Colour.sharedIstance.selectedColour = uiColorFromHex(rgbValue: colorArray[Int(slider.value)])
        Colour.sharedFontIstance.selectedFontColour = uiColorFromHex(rgbValue: colorArray[Int(fontSlider.value)])
        
        self.view.backgroundColor = Colour.sharedIstance.selectedColour
        bgLabel.textColor = Colour.sharedFontIstance.selectedFontColour
        fontLabel.textColor = Colour.sharedFontIstance.selectedFontColour
    }
    
    // Return the rgb values of the colours in the colorArray.
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue = CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    @IBAction func resetClicked(_ sender: UIButton) {
        Colour.sharedIstance.selectedColour = UIColor.white
        Colour.sharedFontIstance.selectedFontColour = UIColor.black
        self.view.backgroundColor = UIColor.white
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
