//
//  SharedUserInfo.swift
//  Naisho
//
//  Created by cao on 2017/03/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation

class UserInfo:NSObject{
    var data: [String : String] = [
        "first_name" : "",
        "last_name" : "",
        "email" : "",
        "fbID" : "",
        "ll" : "",
        "timezone" : "",
        "gender" : ""
    ]
    
    class var sharedInstance : UserInfo {
        struct Static{
            static let instance : UserInfo = UserInfo();
        }
        return Static.instance;
    }
    
}
