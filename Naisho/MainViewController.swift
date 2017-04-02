//
//  MainViewController.swift
//  Naisho
//
//  Created by cao on 2017/03/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import Mapbox
import SwiftLocation
import KCFloatingActionButton

class MainViewController: BasicViewController {
    
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl:UIRefreshControl!
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull Up to Reload")
        self.refreshControl.addTarget(self, action: #selector(MainViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        
        // Add floating action Button
        let fab = KCFloatingActionButton()
        fab.buttonColor = UIColor.white
        fab.addItem("Settings", icon: UIImage(named: "settings")!)
        fab.addItem("Stars", icon: UIImage(named: "star")!)
        self.view.addSubview(fab)
        
        // set the delegate
        mapView.delegate = MapBoxManager.sharedInstance;
    
        
        // Optionally set a starting point.
        mapView.setCenter(LocationManager.sharedInstance.center, zoomLevel: 7, direction: 0, animated: false)
        mapView.showsUserLocation = true;
        
        // add pins
        for b in RealmManager.sharedInstance.getAllBusinesses(){
            mapView.addAnnotation(MapBoxManager.sharedInstance.getPin(title: b.name, location: CLLocationCoordinate2D(latitude: b.lat,longitude: b.lon), subtitile: b.name));
        }
        
    }

    func refresh()
    {
        FourSquareManager.sharedInstance.search(ll: appDelegate.lManager.center, limit: 10, category: Category.EastAsian, radius: "4000",refresh: self.refreshControl,mapview: self.mapView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
