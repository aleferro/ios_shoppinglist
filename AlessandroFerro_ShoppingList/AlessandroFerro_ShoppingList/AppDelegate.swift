//
//  AppDelegate.swift
//  AlessandroFerro_ShoppingList
//
//  Created by Alessandro FERRO (001076795) on 16/10/19.
//  Copyright © 2019 Alessandro FERRO (001076795). All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var itemsArray:[Shopping] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        copyDatabase()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore  application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // Set SQLite to be used within the app with the database shopping.db.
    func getDBPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDir = paths[0]
        let databasePath = (documentsDir as NSString).appendingPathComponent("shopping.db")
        return databasePath;
    }
    
    func copyDatabase() {
        
        let fileManager = FileManager.default
        
        let dbPath = getDBPath()
        var success = fileManager.fileExists(atPath: dbPath)
        
        if(!success) {
            if let defaultDBPath = Bundle.main.path(forResource: "shopping", ofType: "db") {
                
                var error: NSError?
                do {
                    try fileManager.copyItem(atPath: defaultDBPath, toPath: dbPath)
                    success = true
                } catch let error1 as NSError {
                    error = error1
                    success = false
                }
                print(defaultDBPath)
                if(!success) {
                    print("Failed to create writable database file with message\(error!.localizedDescription))")
                }
            }else {
                print("File Already Exists At: \(dbPath)")
            }
        }
    }
}

