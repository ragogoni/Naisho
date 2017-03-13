//
//  ViewController.swift
//  Naisho
//
//  Created by cao on 2017/03/08.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import SwiftLocation
import CoreLocation

class LogInViewController: BasicViewController, FBSDKLoginButtonDelegate {
    
    let ffManager = FirebaseFacebookManager.sharedInstance;
    
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("LogOut")
    }

    /**
     Sent to the delegate when the button was used to login.
     - Parameter loginButton: the sender
     - Parameter result: The results of the login
     - Parameter error: The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("ログイン処理を実行")
        
        if (error != nil) {
            // エラーが発生した場合
            print("Process Error !")
        } else if result.isCancelled {
            // ログインをキャンセルした場合
            print("User Cancelled")
        } else {
            // その他
            print("Login Succeeded")
            ffManager.FireBaseAuthWithFB();
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // testing Foursquare Client API
        let fs = FSClient();
        fs.searchExample();
        
        // get Facebook Login Button
        let loginBtn : FBSDKLoginButton = ffManager.getFBLoginButton();
        self.view.addSubview(loginBtn);
        loginBtn.center = self.view.center;
        loginBtn.delegate = self
        
        //ffManager.FBGraphRequest(nextCursor: nil);
        
        // Request Location record it to userdefaults only when there is a significant change
        Location.getLocation(accuracy: .city, frequency: .significant, success: { (_, location) in
            UserDefaults.standard.setValue(String(describing:location.coordinate.longitude), forKeyPath: "lon");
            UserDefaults.standard.setValue(String(describing:location.coordinate.latitude), forKeyPath: "lat");
            self.ffManager.UpdateUserInfo();
        }) { (request, last, error) in
            request.cancel() // stop continous location monitoring on error
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

