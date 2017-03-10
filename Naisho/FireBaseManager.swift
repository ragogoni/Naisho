//
//  FireBaseManager.swift
//  Naisho
//
//  Created by cao on 2017/03/10.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class FirebaseFacebookManager:NSObject{
    override init(){
        super.init()
    }
    
    public func FireBaseAuthWithFB(){
        let accessToken = FBSDKAccessToken.current()
        
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: (accessToken?.tokenString)!)
        
        // Perform login by calling Firebase APIs
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if let error = error {
                
                // Error Handler
                // Generate Alert
                /*
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                */
                return
            }
            
            // Present the main view
            /*
             if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
             UIApplication.shared.keyWindow?.rootViewController = viewController
             self.dismiss(animated: true, completion: nil)
             }*/
            
        })
    }
    
    func getFBLoginButton()->FBSDKLoginButton{
        let loginBtn : FBSDKLoginButton = FBSDKLoginButton();
        loginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        return loginBtn;
    }
    

}
