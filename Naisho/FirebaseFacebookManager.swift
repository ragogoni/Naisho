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
                
                print("Error during FireBase Authorization:")
                print(error);
                
                
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
        - firstname, lastname
        - birthday
        - max and min age range
        - gender
        - timezone
        - email
     */
    func UpdateUserInfo(){
        let userDefaults = UserDefaults.standard
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,first_name,last_name,age_range,gender,timezone,birthday"]).start(completionHandler: { (connection, result, error) -> Void in
                if(error == nil){
                    let json = JSON(result!);
                    for(tag,data):(String,JSON) in json {
                        // I dont think facebook ID is necessary
                        if(tag == "id"){
                            continue;
                        }
                        
                        if (data != JSON.null && tag == "timezone"){
                            userDefaults.set(data.int!,forKey: tag);
                        } else if (tag == "age_range"){
                            if(data["max"] != JSON.null){
                                userDefaults.set(data["max"].int!,forKey: "max");
                            } else if (data["min"] != JSON.null){
                                userDefaults.set(data["min"].int!,forKey: "min");
                            }
                        } else {
                            userDefaults.set(data.string,forKey: tag);
                        }
                    }// end of for loop for json
                    
                    // testing UserDefaults
                    /*
                    for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
                        print("\(key) = \(value) \n")
                    }*/
                    
                    // synchronize into data
                    userDefaults.synchronize()
                }
    
                }
            )
        }
    }
    
    
    func FBGraphRequest(nextCursor : String?){
        var params = Dictionary<String, String>() as Dictionary?
        
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
