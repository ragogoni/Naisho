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
    let client = FoursquareAPIClient(clientId: "P144FFFTUUBLODLZPVOTHSHUKD5OSKK4HTABYVTGFUBWZDKA", clientSecret: "HLLAOJG2XSZCY0ZDF0XY5HKN1NEUSNC4FXKDA3AYAICK2CNL")
    
    // Search By Example. Simply print the JSON.
    func searchExample(){
        let parameter: [String: String] = [
            "ll": "35.702069,139.7753269",
            "limit": "10",
            ];
        
        client.request(path: "venues/search", parameter: parameter) {
            [weak self] result in
            
            switch result {
                
            case let .success(data):
                // parse the JSON data with NSJSONSerialization or Lib like SwiftyJson
                let json = JSON(data: data) // e.g. {"meta":{"code":200},"notifications":[{"...
                print(json)
            case let .failure(error):
                // Error handling
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
}
