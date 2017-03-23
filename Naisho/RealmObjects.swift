//
//  RealmObjects.swift
//  Naisho
//
//  Created by cao on 2017/03/09.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation


/**
 
 One liner REALM browser opener :
 open $(find ~/Library/Developer/CoreSimulator/Devices/$(ls -t1 ~/Library/Developer/CoreSimulator/Devices/ | head -1)/data/Containers/Data/Application/ -name \*.realm)
 */


class Business : Object{
    dynamic var name = "";
    dynamic var distance: Int = 0;
    dynamic var phone = "";
    dynamic var location = "";
}

class RealmManager:NSObject{
    
    static var sharedInstance: RealmManager = {
        return RealmManager();
    }()
    
    private override init(){
        super.init();
    }
    
    private var realm:Realm = try! Realm();
    
    func writeBusiness(business:Business){
        try! realm.write {
            realm.add(business);
        }
    }
    
    func writeMultipleBusinesses(businesses:[Business]){
        for b in businesses{
            try! realm.write {
                realm.add(b);
            }
        }
    }
    
    func removeAllEntries(){
        try! realm.write {
            realm.deleteAll()
        }
    }
}
