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
    
    func updateLocalArrayOn(category:Category,action:UserAction){
        let defaults = UserDefaults.standard
        var array = defaults.array(forKey: "LocalCategoryArray")  as? [Int] ?? [Int]()
        
        switch category {
        case Category.EastAsian:
            array[0] += action.rawValue
            break
            
        case Category.French:
            array[1] += action.rawValue
            break
            
        case Category.Italian:
            array[2] += action.rawValue
            break
            
        case Category.LatinAmerican:
            array[3] += action.rawValue
            break
            
        case Category.Mexican:
            array[4] += action.rawValue
            break
            
        case Category.Turkish:
            array[5] += action.rawValue
            break
            
        case Category.Indonesian:
            array[6] += action.rawValue
            break
            
        case Category.Indian:
            array[7] += action.rawValue
            break
            
        case Category.Greek:
            array[8] += action.rawValue
            break
            
        case Category.Mediterranean:
            array[9] += action.rawValue
            break
            
        case Category.Spanish:
            array[10] += action.rawValue
            break
            
        case Category.Vegetarian:
            array[11] += action.rawValue
            break
        }
        
        defaults.set(array, forKey: "LocalCategoryArray")
        defaults.synchronize()
    }
    
    
}
