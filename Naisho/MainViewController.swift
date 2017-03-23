//
//  MainViewController.swift
//  Naisho
//
//  Created by cao on 2017/03/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import Mapbox

class MainViewController: BasicViewController, MGLMapViewDelegate {

    let facebookManager:FacebookManager = FacebookManager.sharedInstance;
    let foursquareManager:FourSquareManager = FourSquareManager.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
