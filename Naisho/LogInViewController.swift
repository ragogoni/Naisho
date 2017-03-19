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

class LogInViewController: BasicViewController, FBSDKLoginButtonDelegate {
    
    let facebookManager = FacebookManager.sharedInstance;
    let firebaseManager = FirebaseManager.sharedInstance;
    
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
            // Perform login by calling Firebase APIs
            firebaseManager.auth();
            // dismiss itself
            let storyboard = self.storyboard;
            
            // Present the main view and set it to the root
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "MainView"){
                UIApplication.shared.keyWindow?.rootViewController = viewController
            } // dont forget to tell the view controller to dismiss itself
            
            self.dismiss(animated: true, completion: nil)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // testing Foursquare Client API
        //let fs = FSClient();
        //fs.searchExample();
        
        // get Facebook Login Button
        let loginBtn : FBSDKLoginButton = facebookManager.getFBLoginButton();
        self.view.addSubview(loginBtn);
        loginBtn.center = self.view.center;
        loginBtn.delegate = self
        
        //facebookManager.FBGraphRequest(nextCursor: nil);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

