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
import UIKit
import Mapbox
import PKHUD

enum Category:String{
    case EastAsian = "4bf58dd8d48988d142941735"
    case French = "4bf58dd8d48988d10c941735"
    case Italian = "4bf58dd8d48988d110941735"
    case LatinAmerican = "4bf58dd8d48988d1be941735"
    case Mexican = "4bf58dd8d48988d1c1941735"
    case Turkish = "4f04af1f2fb6e1c99f3db0bb"
    case Indonesian = "4deefc054765f83613cdba6f"
    case Indian = "4bf58dd8d48988d10f941735"
    case Greek = "4bf58dd8d48988d10e941735"
    case Mediterranean = "4bf58dd8d48988d1c0941735"
    case Spanish = "4bf58dd8d48988d150941735"
    case Vegetarian = "4bf58dd8d48988d1d3941735"
    // case Steakhouse = "4bf58dd8d48988d1cc941735"
    // case Soulfood = "4bf58dd8d48988d14f941735"
    // case Foodtruck = "4bf58dd8d48988d1cb941735"
    // case Thai = "4bf58dd8d48988d149941735"
    //    case Chinese = "4bf58dd8d48988d145941735"
    //    case Japanese = "4bf58dd8d48988d111941735"
    //    case Korean = "4bf58dd8d48988d113941735"
    // case MiddleEastern = "4bf58dd8d48988d115941735"
    // case Jewish = "52e81612bcbc57f1066b79fd"
    // case American = "4bf58dd8d48988d14e941735"
    // case Filipino = "4eb1bd1c3b7b55596b4a748f"
    //    case Brazilian = "4bf58dd8d48988d16b941735"
    //    case Peruvian = "4eb1bfa43b7b52c0e1adc2e8"
    case Nil = ""
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
    func search(ll:CLLocationCoordinate2D,limit:Int,category:Category?,radius:String?,mapview:MGLMapView?,tableView:UITableView?, refreshControl:UIRefreshControl?, removeAllEntries: Bool){
        var param:[String:String]
        
        // convert CLLocationCoordinate2D to string so that we can do API call
        let loc = String(describing:ll.latitude) + "," + String(describing:ll.longitude);
        
        // Update Parameters
        param = ["ll":loc,"limit":String(limit)];
        
        if(loc == "0.0,0.0"){
            return;
        }
        
        param["radius"] = (radius != nil) ? radius! : nil;
        
        
        // if the category is nil, search in general restaurant category
        if(category != nil){
            param["categoryId"] = category!.rawValue;
        } else {
            param["categoryId"] = "4d4b7105d754a06374d81259";
        }
        
        client.request(path: FourSquareManager.SEARCH_PATH, parameter: param){
            result in
            
            switch result {
                
            case let .success(data):
                self.json = JSON(data: data)
                //print(self.json)
                
                if(removeAllEntries){
                    RealmManager.sharedInstance.removeAllEntries()
                }
                
                for(_,subjson):(String,JSON) in self.json["response"]["venues"]{
                    if (subjson["location"]["distance"] != JSON.null && subjson["contact"]["phone"] != JSON.null && subjson["hasMenu"].boolValue){
                        
                        let b:Business = Business()
                        b.distance = subjson["location"]["distance"].int!
                        b.phone = subjson["contact"]["phone"].string!
                        b.name = subjson["name"].string!
                        b.lat = subjson["location"]["lat"].double!
                        b.lon = subjson["location"]["lng"].double!
                        b.id = subjson["id"].string!
                        b.category = subjson["categories"][0]["pluralName"].string!
                        b.menuURL = subjson["menu"]["mobileUrl"].string!
                        RealmManager.sharedInstance.writeBusiness(business: b);
                        
                        // get the photos
                        self.searchPhoto(venueID: subjson["id"].string!);
                        self.searchVenue(venueID: subjson["id"].string!);
                    }
                    
                }
                
                // reload the data if the tableview is set
                if tableView != nil {
                    tableView!.reloadData()
                }
                
                
                // put pins on the mapview if it is given
                if(mapview != nil){
                    // Optionally set a starting point.
                    mapview!.setCenter(LocationManager.sharedInstance.center, zoomLevel: 12, direction: 0, animated: false)
                    
                    // add pins
                    for b in RealmManager.sharedInstance.getAllBusinesses(){
                        mapview!.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location: CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
                    }
                }
                
                // end refreshing if its given
                if(refreshControl != nil){
                    refreshControl?.endRefreshing()
                }
                
                // flash success for 0.5 secs
                HUD.flash(.success, delay: 0.5)
                
                // set the refreshed key to be true
                UserDefaults.standard.set(true, forKey: "refreshed")
                UserDefaults.standard.synchronize()
                
                print("DEBUG: Finished searching venues on Foursquare.")
                
                
            case let .failure(error):
                switch error{
                case let .connectionError(connectionError):
                    print(connectionError)
                case let .apiError(apiError):
                    print(apiError.errorType)   // e.g. endpoint_error
                    print(apiError.errorDetail) // e.g. The requested path does not exist.
                }
                
                if(refreshControl != nil){
                    refreshControl?.endRefreshing()
                }
                
                HUD.show(.error)
                HUD.hide(afterDelay: 0.5)
            }
        }
    }
    
    func searchVenue(venueID:String){
        let VENUE_PATH = "venues/@".replacingOccurrences(of: "@", with: venueID)
        
        client.request(path: VENUE_PATH, parameter: ["VENUE_ID":venueID]){
            result in
            
            switch result{
            
            case let .success(data):
                let j = JSON(data)["response"]["venue"]
                
                if(j["bestPhoto"] != JSON.null && j["bestPhoto"]["prefix"] != JSON.null && j["bestPhoto"]["suffix"] != JSON.null){
                    RealmManager.sharedInstance.writeBestPhotoURLOn(ID: venueID, url: j["bestPhoto"]["prefix"].string!+"300x300"+j["bestPhoto"]["suffix"].string!)
                }
                
                if(j["rating"] != JSON.null){
                    RealmManager.sharedInstance.writeRatingOn(ID: venueID,rating: j["rating"].double!)
                }
                
                if(j["hours"] != JSON.null){
                    RealmManager.sharedInstance.writeIsOpenOn(ID: venueID,isOpen:j["hours"]["isOpen"].bool!)
                }
                if(j["price"] != JSON.null){
                    RealmManager.sharedInstance.writePriceOn(ID: venueID, price: j["price"]["tier"].int!)
                }
                if(j["likes"] != JSON.null){
                    RealmManager.sharedInstance.writeLikesOn(ID: venueID, likes: j["likes"]["count"].int!)
                }
                
                
                break;
                
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
    
    // search for the very first photo
    func searchPhoto(venueID:String){
        // Search Path for Photos e.g venues/VENUE_ID/photos
        // need to replace @ with the venue ID
        let PHOTO_PATH = "venues/@/photos".replacingOccurrences(of: "@", with: venueID)
        let param:[String:String] = ["limit":"3","VENUE_ID":venueID]
        
        client.request(path: PHOTO_PATH, parameter: param){
            result in
            
            switch result{
            case let .success(data):
                // update the photo count
                let j = JSON(data)
                
                var url:[String] = [String]()
                
                // restore 0 to 3 photos locally
                for(_,subjson):(String,JSON) in j["response"]["photos"]["items"]{
                    url.append(subjson["prefix"].string!+"300x300"+subjson["suffix"].string!)
                }
                RealmManager.sharedInstance.updatePhotoURLOn(ID: venueID, url: url, count: j["response"]["photos"]["count"].int!)
                break
                
                
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
    
    func categoryOfIndex(index: Int) -> Category{
        switch index{
        case 0:
            return Category.EastAsian
        case 1:
            return Category.French
        case 2:
            return Category.Italian
        case 3:
            return Category.LatinAmerican
        case 4:
            return Category.Mexican
        case 5:
            return Category.Turkish
        case 6:
            return Category.Indonesian
        case 7:
            return Category.Indian
        case 8:
            return Category.Greek
        case 9:
            return Category.Mediterranean
        case 10:
            return Category.Spanish
        case 11:
            return Category.Vegetarian
        default:
            return Category.Nil
        }
        
    }
    
    // return the category from the category string accordings to the Foursquare API
    func categoryFromRawString(categoryString :String)->Category{
        switch categoryString{
        case "Asian Restaurants", "Chinese Restaurants", "Japanese Restaurants", "Korean Restaurants", "Filipino Restaurants", "Thai Restaurants", "Vietnamese Restaurants", "Dim Sum Restaurants", "Ramen Restaurants", "Sushi Restaurants":
            return Category.EastAsian
        case "French Restaurants":
            return Category.French
        case "Indonesian Restaurants":
            return Category.Indonesian
        case "Indian Restaurants", "Pakistani Restaurants":
            return Category.Indian
        case "Italian Restaurants", "Pizza Places":
            return Category.Italian
        case "Latin American Restaurants", "Brazilian Restaurants", "Argentinian Restaurants", "Peruvian Restaurants", "Churrascarias":
            return Category.LatinAmerican
        case "Mexican Restaurants", "Burrito Places", "Taco Places":
            return Category.Mexican
        case "Spanish Restaurants", "Tapas Restaurants":
            return Category.Spanish
        case "Turkish Restaurants":
            return Category.Turkish
        case "Greek Restaurants", "Meze Restaurants":
            return Category.Greek
        case "Vegetarian / Vegan Restaurants","Salad Places":
            return Category.Vegetarian
        case "Mediterranean Restaurants":
            return Category.Mediterranean
        default:
            return Category.Nil
        }
    
    }
    
    
    func index(c:Category) -> Int{
        switch c{
        case Category.EastAsian:
            return 0
        case Category.French:
            return 1
        case Category.Italian:
            return 2
        case Category.LatinAmerican:
            return 3
        case Category.Mexican:
            return 4
        case Category.Turkish:
            return 5
        case Category.Indonesian:
            return 6
        case Category.Indian:
            return 7
        case Category.Greek:
            return 8
        case Category.Mediterranean:
            return 9
        case Category.Spanish:
            return 10
        case Category.Vegetarian:
            return 11
        case Category.Nil:
            return -1
        }
    }
    
    
    func ratioSearch(ll:CLLocationCoordinate2D,mapview:MGLMapView?,tableView:UITableView?, refreshControl:UIRefreshControl?){
        
        // remove all the instance
        RealmManager.sharedInstance.removeAllEntries()
        
        // get the ratio
        let array = MLManager.sharedInstance.getLocalArray()
        let sum = array.reduce(0, +)
        
        // not enough infomation
        if(sum == 0){
            return
        }
        
        
        var ratioArray = [Int](repeating: 0, count: 12)
        
        for i in 0 ..< 12{
            ratioArray[i] = Int(ceil(Double((array[i]))/(Double(sum))*10))
        }
        
        
        for i in 0 ..< 12{
            self.search(ll: ll, limit: ratioArray[i]+2, category: self.categoryOfIndex(index: i), radius: "7000", mapview: mapview, tableView: tableView, refreshControl: refreshControl, removeAllEntries: false)
        }
        
    }
    
}
