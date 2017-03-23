//
//  FSClient.swift
//  Naisho
//
//  Created by cao on 2017/03/09.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import FoursquareAPIClient
import SwiftyJSON
import CoreLocation

enum Category:String{
    case EastAsian = "4bf58dd8d48988d142941735"
    //    case Chinese = "4bf58dd8d48988d145941735"
    //    case Japanese = "4bf58dd8d48988d111941735"
    //    case Korean = "4bf58dd8d48988d113941735"
    case French = "4bf58dd8d48988d10c941735"
    case Italian = "4bf58dd8d48988d110941735"
    case LatinAmerican = "4bf58dd8d48988d1be941735"
    //    case Brazilian = "4bf58dd8d48988d16b941735"
    //    case Peruvian = "4eb1bfa43b7b52c0e1adc2e8"
    case Mexican = "4bf58dd8d48988d1c1941735"
    case Turkish = "4f04af1f2fb6e1c99f3db0bb"
    // case American = "4bf58dd8d48988d14e941735"
    // case Filipino = "4eb1bd1c3b7b55596b4a748f"
    case Indonesian = "4deefc054765f83613cdba6f"
    case Indian = "4bf58dd8d48988d10f941735"
    case Greek = "4bf58dd8d48988d10e941735"
    // case Jewish = "52e81612bcbc57f1066b79fd"
    case Mediterranean = "4bf58dd8d48988d1c0941735"
    // case MiddleEastern = "4bf58dd8d48988d115941735"
    case Spanish = "4bf58dd8d48988d150941735"
    case Vegetarian = "4bf58dd8d48988d1d3941735"
    // case Steakhouse = "4bf58dd8d48988d1cc941735"
    // case Soulfood = "4bf58dd8d48988d14f941735"
    // case Foodtruck = "4bf58dd8d48988d1cb941735"
    case Thai = "4bf58dd8d48988d149941735"
}

class FourSquareManager:NSObject{
    
    // Search Path static string
    static let SEARCH_PATH = "venues/search";
    
    // Json Data that is querried. Initialize with NULL
    var json:JSON = [:];
    
    // Location
    let lManager = LocationManager.sharedInstance;
    
    // FourSquare API Client
    let client = FoursquareAPIClient(clientId: "P144FFFTUUBLODLZPVOTHSHUKD5OSKK4HTABYVTGFUBWZDKA", clientSecret: "HLLAOJG2XSZCY0ZDF0XY5HKN1NEUSNC4FXKDA3AYAICK2CNL")
    
    // sharedInstance
    static var sharedInstance: FourSquareManager = {
        return FourSquareManager();
    }()
    
    
    private override init() {
        super.init()
    }
    
    
    // Search By Example. Simply print the JSON.
    func searchExample(){
        let parameter: [String: String] = [
            "ll": "35.702069,139.7753269",
            "limit": "10",
            ];
        client.request(path: FourSquareManager.SEARCH_PATH, parameter: parameter) {
            result in
            
            switch result {
                
            case let .success(data):
                // parse the JSON data with NSJSONSerialization or Lib like SwiftyJson
                self.json = JSON(data: data)
            case let .failure(error):
                switch error {
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }
        }
    }
    
    
    // search by location and category
    func search(ll:String?,limit:Int,currentLocation: Bool, category:Category?,radius:String?){
        var param:[String:String]
        
        if(currentLocation){
            lManager.updateUserLocationInUserDefaultsOnce();
            let loc:String = UserDefaults.standard.string(forKey: "lat")! + "," + UserDefaults.standard.string(forKey: "lon")!
            param = ["ll":loc,"limit":String(limit)];
        } else {
            param = ["ll":ll!,"limit":String(limit)];
        }
        
        param["radius"] = (radius != nil) ? radius! : nil;
        
        // if the category is nil, search in general restaurant category
        if(category != nil){
            param["categoryId"] = category!.rawValue;
        } else {
            param["categoryId"] = "4d4b7105d754a06374d81259";
            param["query"] = "Restaurant"
        }
        
        client.request(path: FourSquareManager.SEARCH_PATH, parameter: param){
            result in
            
            switch result {
                
            case let .success(data):
                self.json = JSON(data: data)
                
                
                RealmManager.sharedInstance.removeAllEntries()
                
                for(_,subjson):(String,JSON) in self.json["response"]["venues"]{
                    /*
                    print("name: ", subjson["name"])
                    print("distance: ", subjson["location"]["distance"])
                    print("phone: ", subjson["contact"]["phone"])
                    print("location: ", (subjson["location"]["lat"]) ,(subjson["location"]["lng"]),"\n")*/
                    // TODO: Need to get it's price range too
                    
                    if (subjson["name"] != JSON.null && subjson["location"]["distance"] != JSON.null && subjson["contact"]["phone"] != JSON.null && subjson["location"]["lat"] != JSON.null && subjson["location"]["lng"] != JSON.null){
                        
                        let b:Business = Business()
                        b.distance = subjson["location"]["distance"].int!
                        b.phone = subjson["contact"]["phone"].string!
                        b.name = subjson["name"].string!
                        b.lat = subjson["location"]["lat"].double!
                        b.lon = subjson["location"]["lng"].double!
                        RealmManager.sharedInstance.writeBusiness(business: b);
                    }
                    
                }
                
                //print(self.json)
                //print(param)
            case let .failure(error):
                switch error{
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
            }
        }
    }
    
    
}
