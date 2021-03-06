//
//  AppDelegate.swift
//  Naisho
//
//  Created by cao on 2017/03/08.
//  Copyright © 2017 JustACoin. All rights reserved.
//

/*
 *
 * TODO: Make favorite (saved) view controller
 *          - need to create another Realm db
 *          - put the save icon on the table view
 *
 * TODO: Make the pop-up image when clicked the image in the table view
 *          - make it so that it is scrollable (4 photos at most)
 *          - probably easier just to hardcode it
 *
 * TODO: Add another share button on the left side of the GO button
 *          - use some library from github
 *
 * TODO: Make the foursquare search better
 *          - it searches only the restaurants that is open
 *          - it searches with the ratio of the internal rating system
 *          - get the equation of deriving the ratio from the user actions
 *
 * TODO: Settings
 *          - Name, Photo, ID, Description
 *          - Report a Problem
 *          - Credits
 *
 * TODO: Navigation view when clicked the GO button
 *
 */

import UIKit
import FBSDKCoreKit
import Firebase
import FirebaseAnalytics
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let lManager = LocationManager.sharedInstance;
    
    override init() {
        super.init()
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true
        lManager.continuouslyUpdateUserLocation();
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL!,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation] as Any
        )
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url as URL!,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //lManager.updateUserLocationInUserDefaultsOnce();
        
        // if already logged in, skip the login View
        if((FBSDKAccessToken.current()) != nil){
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = appDelegate.window?.rootViewController?.storyboard
            
            
            // Present the main view and set it to the root
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "TabBar"){
                if let window = self.window{
                    window.rootViewController = viewController
                }
            }
            
            // FacebookManager.sharedInstance.UpdateUserInfo();
        }
        
        print("hi")
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
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
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }


}

