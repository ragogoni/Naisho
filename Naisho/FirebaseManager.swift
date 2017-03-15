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
    
    func auth() {
        FIRAuth.auth()?.signIn(with: FIRFacebookAuthProvider.credential(withAccessToken: (FBSDKAccessToken.current()?.tokenString)!), completion: { (user, error) in
            if let error = error {
                print(error);
                return
            }
            
            // Set uid into UserDefaults
            UserDefaults.standard.set(user?.uid as String!, forKey: "uid");
            UserDefaults.standard.synchronize();
            
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let storyboard = appDelegate.window?.rootViewController?.storyboard
            
            
            // Present the main view and set it to the root
            if let viewController = storyboard?.instantiateViewController(withIdentifier: "MainView"){
                UIApplication.shared.keyWindow?.rootViewController = viewController
            } // dont forget to tell the view controller to dismiss itself
            
            
        })
    }
    
    /*
    func saveDataOnUser(data: Dictionary<String,String>){
        
        let ref = FIRDatabase.database().reference()
        // What can be saved and what cannot be saved
        for (key,val) in data{
            if(validKeys.contains(key)){
                //self.ref.child("users/(user.uid)/username").setValue(username)
                ref.child("users/(user.uid)/"+key).setValue(val)
            }
        }
        
    }*/ //Probably Useless
    
    
    func saveOneDataOnUser(tagUnderUserUID: String, val: Any){
        if( UserDefaults.standard.value(forKey: "uid") == nil){
            print("null uid")
            return;
        }
        var data:Any;
        
        if(val is Int){
            data = val as! Int
        } else {
            data = val as! String
        }
        
        let uid = UserDefaults.standard.value(forKey: "uid") as! String;
        
        
        if(validKeys.contains(tagUnderUserUID)){
            FIRDatabase.database().reference().child("users/"+uid+"/"+tagUnderUserUID).setValue(data)
        }
    }
    
    
    
}
