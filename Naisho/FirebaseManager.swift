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
import FirebaseDatabase

class FirebaseManager:NSObject{
    
    var validKeys = [String]()
    
    static var sharedInstance: FirebaseManager = {
        return FirebaseManager();
    }()
    
    
    private override init(){
        super.init()
        self.configureValidKeys(data: ["last_name","first_name","ll","timezone","gender","email"]);
    }
    
    func configureValidKeys(data: Array<String>){
        for (elem) in data{
            validKeys.append(elem);
        }
    }
    
    // authorize the user and update uid
    func auth() {
        FIRAuth.auth()?.signIn(with: FIRFacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!), completion: { (user, error) in
            if let error = error {
                print(error);
                return
            }
            
            // Set uid into UserDefaults
            UserDefaults.standard.set(user?.uid as String!, forKey: "uid");
            UserDefaults.standard.synchronize();
        })
    }
    
    // Save data on user under tag with value
    func saveOneDataOnUser(tagUnderUserUID: String, val: Any){
        if( UserDefaults.standard.value(forKey: "uid") == nil){
            print("null uid")
            return;
        }
        var data:Any;
        
        switch val {
        case is Int:
            data = val as! Int
            break;
        case is String:
            data = val as! String
            break;
        default:
            data = val as! String
            break;
        }
        
        let uid = UserDefaults.standard.value(forKey: "uid") as! String;
        
        
        if(validKeys.contains(tagUnderUserUID)){
            FIRDatabase.database().reference().child("users/"+uid+"/"+tagUnderUserUID).setValue(data)
        }
    }
    
    // Save data on Collaborative Filetering under tag with value
    // save an array of int that represents user's preference on categories
    func saveDataForCollaborativeFiltering(data: [Int]){
        if( UserDefaults.standard.value(forKey: "uid") == nil){
            print("null uid")
            return;
        }
        let uid = UserDefaults.standard.value(forKey: "uid") as! String;
       FIRDatabase.database().reference().child("CollaborativeFiltering/"+uid).setValue(data)
    }
    
    
    
}
