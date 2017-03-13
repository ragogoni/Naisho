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
import SwiftyJSON

/*
 Singleton Firebase Facebook Manager
 */
class FirebaseFacebookManager:NSObject{
    
    static var sharedInstance: FirebaseFacebookManager = {
        return FirebaseFacebookManager();
    }()

    
    private override init(){
    }
    
    func FireBaseAuthWithFB(){
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
    
    /* get facebook button */
    func getFBLoginButton()->FBSDKLoginButton{
        let loginBtn : FBSDKLoginButton = FBSDKLoginButton();
        loginBtn.readPermissions = ["public_profile", "email", "user_friends"];
        return loginBtn;
    }
    
    /*
     Update the User information into the sharedInstance.
     
     Updating:
        - firstname
        - lastname
        - birthday
        - age range
        - gender
        - timezone
        - email
     
     */
    func UpdateUserInfo(){
        let user = UserInfo.sharedInstance;
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,id,first_name,last_name,age_range,gender,timezone,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if(error == nil){
                    let json = JSON(result!);
                    print(json);
                    for(tag,data):(String,JSON) in json {
                        if(json["id"] != JSON.null && tag == "id"){
                            user.data["fbID"] = json["id"].string!;
                        } else if (json["timezone"] != JSON.null && tag == "timezone"){
                            user.data["timezone"] = String(describing: data.int!);
                        } else {
                            user.data[tag] = data.string;
                        }
                    }
                    print(user.data);
                }
    
                }
            )
        }
    }
    
    
    func FBGraphRequest(nextCursor : String?){
        var params = Dictionary<String, String>() as? Dictionary
        
        if nextCursor == nil {
            params = nil
        } else {
            params!["after"] = nextCursor
        }
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me/taggable_friends", parameters: params).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let json = JSON(result!)
                    for (_,subJson):(String, JSON) in json["data"] {
                        print(subJson["name"])
                    }
                    if(json["paging"]["cursors"]["after"] != JSON.null){
                        self.FBGraphRequest(nextCursor: json["paging"]["cursors"]["after"].string);
                    } else {
                        print("End of Page");
                    }
                    
                }
            })
        }
    }
    

}
