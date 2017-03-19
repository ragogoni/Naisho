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

class FSClient:NSObject{
    
    // Search Path static string
    static let SEARCH_PATH = "venues/search";
    
    // Json Data that is querried. Initialize with NULL
    var json:JSON = [:];
    
    // Location
    let lManager = LocationManager.sharedInstance;
    
    // FourSquare API Client
    let client = FoursquareAPIClient(clientId: "P144FFFTUUBLODLZPVOTHSHUKD5OSKK4HTABYVTGFUBWZDKA", clientSecret: "HLLAOJG2XSZCY0ZDF0XY5HKN1NEUSNC4FXKDA3AYAICK2CNL")
    
    
    override init() {
        super.init()
    }
    
    
    // Search By Example. Simply print the JSON.
    func searchExample(){
        let parameter: [String: String] = [
            "ll": "35.702069,139.7753269",
            "limit": "10",
            ];
        client.request(path: FSClient.SEARCH_PATH, parameter: parameter) {
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
    
    
    func search(ll:String,limit:Int,currentLocation: Bool){
        var param:[String:String]
        
        if(currentLocation){
            lManager.updateUserLocationInUserDefaultsOnce();
            let loc:String = UserDefaults.standard.string(forKey: "lat")! + "," + UserDefaults.standard.string(forKey: "lon")!
            param = ["ll":loc,"limit":String(limit)];
        } else {
            param = ["ll":ll,"limit":String(limit)];
        }
        client.request(path: FSClient.SEARCH_PATH, parameter: param){
            result in
            
            switch result {
                
            case let .success(data):
                self.json = JSON(data: data)
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
