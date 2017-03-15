//
//  FirebaseManager.swift
//  Naisho
//
//  Created by cao on 2017/03/15.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit


class FirebaseManager:NSObject{

    
    static var sharedInstance: FirebaseManager = {
        return FirebaseManager();
    }()
    
    
    private override init(){
    }
    
    func auth() {
        FIRAuth.auth()?.signIn(with: FIRFacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!), completion: { (user, error) in
            if let error = error {
                print(error);
                return
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // From there, get your UIStoryboard reference from the
            // rootViewController in your UIWindow
            let rootViewController = appDelegate.window?.rootViewController
            let storyboard = rootViewController?.storyboard
            
            // Present the main view and set it to the root
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "MainView"){
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
            // dont forget to tell the view controller to dismiss itself
        })
    }
}
