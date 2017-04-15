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
    dynamic var id = ""
    dynamic var name = "";
    dynamic var distance: Int = 0;
    dynamic var phone = "";
    dynamic var lat = 0.0;
    dynamic var lon = 0.0;
    dynamic var photoCount = 0;
    
    dynamic var photo_1 = ""
    dynamic var photo_2 = ""
    dynamic var photo_3 = ""
    
    var isOpen = RealmOptional<Bool>(nil)
    var rating = RealmOptional<Double>(nil)
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class RealmManager:NSObject{
    
    static var sharedInstance: RealmManager = {
        return RealmManager();
    }()
    
    private override init(){
        super.init();
    }
    
    private var realm:Realm = try! Realm();
    
    
    func getAllBusinesses()->[Business]{
        return Array(realm.objects(Business.self))
    }
    
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
    
    func writeRatingOn(ID:String,rating:Double){
        if let b = realm.object(ofType: Business.self, forPrimaryKey: ID){
            try! realm.write {
                b.rating.value = rating;
                realm.add(b, update: true)
            }
        }
    }
    
    func writeIsOpenOn(ID:String,isOpen:Bool){
        if let b = realm.object(ofType: Business.self, forPrimaryKey: ID){
            try! realm.write {
                b.isOpen.value = isOpen;
                realm.add(b, update: true)
            }
        }
    }
    
    func getTotalNumber()-> Int{
        return realm.objects(Business.self).count;
    }
    
    func getObjectAtIndex(index:Int)->Business?{
        return realm.objects(Business.self)[index];
    }
    
    func updatePhotoURLOn(ID:String, url:[String],count:Int){
        if let b = realm.object(ofType: Business.self, forPrimaryKey: ID){
            try! realm.write {
                if(count == 3){
                    b.photo_1 = url[0]
                    b.photo_2 = url[1]
                    b.photo_3 = url[2]
                } else if (count == 2){
                    b.photo_1 = url[0]
                    b.photo_2 = url[1]
                } else if (count == 1){
                    b.photo_1 = url[0]
                }
                b.photoCount = count
                realm.add(b, update: true)
            }
        }
        
    }
    
}
