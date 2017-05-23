//
//  CollaborativeFilteringManager.swift
//  Naisho
//
//  Created by cao on 2017/03/28.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation

enum UserAction:Int{
    case OnOpenCell = 1
    case OnClickGo = 4
    case OnClickPhoto = 2
}

// Machine Learning Manager
class MLManager:NSObject{
    
    var ratings:[Int] = [Int](repeating: 0, count: 12)
    
    static var sharedInstance: MLManager = {
        return MLManager();
    }()
    
    private override init(){
        super.init()
    }
    
    // So there are 12 categories right now
    /*
     case EastAsian, French, Italian, LatinAmerican, Mexican, Turkish, Indonesian, Indian, Greek, Mediterranean, Spanish, Vegetarian
     */
    
    func initLocalArray(){
        let array = [Int](repeating: 0, count: 12)
        let defaults = UserDefaults.standard
        defaults.set(array, forKey: "LocalCategoryArray")
        defaults.synchronize()
    }
    
    func getLocalArray() -> [Int]{
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "LocalCategoryArray")  as? [Int] ?? [Int]()
        
        
        if(array.reduce(0, +) > 100){
            for i in 0 ..< 12 {
                array[i] = array[i]/2
            }
        }
        
        defaults.set(array, forKey: "LocalCategoryArray")
        defaults.synchronize()
        
        return array
    }
    
    func updateLocalArrayOn(category:Category,action:UserAction){
        let defaults = UserDefaults.standard
        var array:[Int] = defaults.array(forKey: "LocalCategoryArray") as! [Int]
        
        if(category != Category.Nil){
            array[FourSquareManager.sharedInstance.index(c: category)] += action.rawValue
        }
        
        defaults.set(array, forKey: "LocalCategoryArray")
        defaults.synchronize()
    }
    
    
}
