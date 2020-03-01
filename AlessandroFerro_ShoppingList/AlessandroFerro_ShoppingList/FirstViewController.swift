//
//  FirstViewController.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 16/10/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import UIKit

/*
 Just a menu with alternative navigation.
 Its sole purpose is be cute and have a background.
*/
 
class FirstViewController: UIViewController {
 
    @IBOutlet weak var devLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var shopAppLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var itemsArray:[Shopping] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        itemsArray = appDelegate.itemsArray
        
        assignBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func shoppingListBtnClicked(_ sender: UIButton) {
        //performSegue(withIdentifier: "thirdSegue", sender: self)
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 1
    }
    
    @IBAction func addItemBtnClicked(_ sender: UIButton) {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 2
    }
    
    
    @IBAction func settingsBtnClicked(_ sender: UIButton) {
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        tabBarController.selectedIndex = 3
    }
    
    func assignBackground(){
        let background = UIImage(named: "background.jpg")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
}

