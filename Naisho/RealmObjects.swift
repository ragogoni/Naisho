//
//  RealmObjects.swift
//  Naisho
//
//  Created by cao on 2017/03/09.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import RealmSwift

class UserInfo:Object{
    dynamic var first_name = "";
    dynamic var last_name = "";
    dynamic var email = "";
    dynamic var fbID = 0;
    dynamic var ll = "";
}
