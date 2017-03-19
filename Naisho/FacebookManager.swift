//
//  FireBaseManager.swift
//  Naisho
//
//  Created by cao on 2017/03/10.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON

/*
 Singleton Firebase Facebook Manager
 */
class FacebookManager:NSObject{
    
    let firebaseManager:FirebaseManager = FirebaseManager.sharedInstance;
    
    static var sharedInstance: FacebookManager = {
        return FacebookManager();
    }()

    
    private override init(){
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
                            self.firebaseManager.saveOneDataOnUser(tagUnderUserUID: tag, val: data.int!)
                        } else if (tag == "age_range"){
                            if(data["max"] != JSON.null){
                                userDefaults.set(data["max"].int!,forKey: "max");
                            } else if (data["min"] != JSON.null){
                                userDefaults.set(data["min"].int!,forKey: "min");
                            }
                        } else {
                            userDefaults.set(data.string,forKey: tag);
                            self.firebaseManager.saveOneDataOnUser(tagUnderUserUID: tag, val: data.string!)
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
    
    
    // graph request getting all information of user's friend
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
