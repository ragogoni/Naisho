//
//  SimpleTableViewController.swift
//  Naisho
//
//  Created by cao on 2017/04/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import FoldingCell
import SDWebImage
import MapboxDirections
import Mapbox

class SimpleTableViewController: UITableViewController {

    private var cellHeights: [CGFloat] = []
    
    private let kCloseCellHeight: CGFloat = 164 //150+14
    private let kOpenCellHeight: CGFloat = 466  //450+16
    
    let colors = [UIColor(red:0.72, green:0.20, blue:0.39, alpha:1.0),
                  UIColor(red:0.51, green:0.91, blue:0.26, alpha:1.0),
                  UIColor(red:0.20, green:0.60, blue:0.72, alpha:1.0),
                  UIColor(red:0.92, green:0.48, blue:0.26, alpha:1.0)]
    
    private let directions = Directions(accessToken: "pk.eyJ1Ijoidml4YWVyIiwiYSI6ImNpczBneDM0cjAzYjUyenA4eXV1N2Zpb2UifQ.D2L9Dd674rBGVuallWx3RQ")
    
    private let locationManager = LocationManager.sharedInstance;

    
    override func viewWillAppear(_ animated: Bool) {
        for _ in 0...RealmManager.sharedInstance.getTotalNumber() {
            cellHeights.append(kCloseCellHeight)
        }
        
        self.tableView.reloadData()
        
        super.viewWillAppear(animated)
        
        print("DEBUG: TableView ViewWillAppear")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        
        
        for _ in 0...RealmManager.sharedInstance.getTotalNumber() {
            cellHeights.append(kCloseCellHeight)
        }
        
        // refresher
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "Pull to reload")
        self.refreshControl?.addTarget(self, action: #selector(SimpleTableViewController.refresh), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl!)
        
        // if both lat and lon are available, search
        if let lat = UserDefaults.standard.string(forKey:"lat"){
            if let lon = UserDefaults.standard.string(forKey:"lon"){
                var loc = CLLocationCoordinate2D();
                loc.latitude = Double(lat)!;
                loc.longitude = Double(lon)!;
                FourSquareManager.sharedInstance.search(ll: loc, limit: 20,category: nil, radius: "3000",mapview: nil, tableView: self.tableView, refreshControl: nil, removeAllEntries: true)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RealmManager.sharedInstance.getTotalNumber();
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        for _ in 0...RealmManager.sharedInstance.getTotalNumber() {
            cellHeights.append(kCloseCellHeight)
        }
        return cellHeights[(indexPath as NSIndexPath).row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! SampleCell
        
        if(cell.isAnimating()){
            return;
        }
        
        if let b = RealmManager.sharedInstance.getObjectAtIndex(index: indexPath.row){
            
            // add 1 point to the internal array on the category
            MLManager.sharedInstance.updateLocalArrayOn(category: FourSquareManager.sharedInstance.categoryFromRawString(categoryString: b.category), action: UserAction.OnOpenCell)
            
            // remove annotations
            if cell.containerMapView.annotations?.isEmpty == false{
                for a in cell.containerMapView.annotations!{
                    cell.containerMapView.removeAnnotation(a)
                }
            }
            
            // configure the map
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: b.lat, longitude: b.lon)
            point.title = b.name
            cell.containerMapView.addAnnotation(point)
            
            
            // calculate the distance and show it on the map
            let lat = Double(UserDefaults.standard.string(forKey:"lat")!)!;
            let lon = Double(UserDefaults.standard.string(forKey:"lon")!)!;
            
            let waypoints = [
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), name: "Start Position"),
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: b.lat, longitude: b.lon), name: b.name),
                ]
            let options = RouteOptions(waypoints: waypoints, profileIdentifier: .walking)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                
                if let route = routes?.first{ //if let route = routes?.first, let leg = route.legs.first
                    
                    //print("Route via \(leg):")
                    
                    
                    //let distanceFormatter = LengthFormatter()
                    //let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                    
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .short
                    formatter.allowedUnits = [.minute]
                    let formattedTravelTime = formatter.string(from: route.expectedTravelTime)
                    
                    //print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                    
                    cell.fgDistanceLabel.text = "~"+formattedTravelTime!
                    cell.containerDistanceLabel.text = "~" + formattedTravelTime!
                    
                    /*
                     for step in leg.steps {
                     //print("\(step.instructions)")
                     let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
                     //print("— \(formattedDistance) —")
                     }*/
                    
                    if route.coordinateCount > 0 {
                        // Convert the route’s coordinates into a polyline.
                        var routeCoordinates = route.coordinates!
                        let routeLine = MGLPolyline(coordinates: &routeCoordinates, count: route.coordinateCount)
                        
                        // Add the polyline to the map and fit the viewport to the polyline.
                        cell.containerMapView.addAnnotation(routeLine)
                        cell.containerMapView.setVisibleCoordinates(&routeCoordinates, count: route.coordinateCount, edgePadding: .zero, animated: true)
                    }
                }
            }
            
            // reset the price tier
            switch b.price {
            case 1:
                cell.fgPriceLabel.text = "$"
                cell.containerPriceLabel.text = "Affordable (~10 USD)"
            case 2:
                cell.fgPriceLabel.text = "$$"
                cell.containerPriceLabel.text = "Safely Priced (11~20 USD)"
            case 3:
                cell.fgPriceLabel.text = "$$$"
                cell.containerPriceLabel.text = "Expensive (21~35 USD)"
            case 4:
                cell.fgPriceLabel.text = "$$$$"
                cell.containerPriceLabel.text = "Fancy Fancy (~36 USD)"
            default:
                cell.fgPriceLabel.text = "N/A"
                cell.containerPriceLabel.text = "N/A"
            }
        }
        
        
        var duration = 0.0
        if cellHeights[(indexPath as NSIndexPath).row] == kCloseCellHeight { // open cell
            cellHeights[(indexPath as NSIndexPath).row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {// close cell
            cellHeights[(indexPath as NSIndexPath).row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as SampleCell = cell else { return }
        if let b = RealmManager.sharedInstance.getObjectAtIndex(index: indexPath.row){
            cell.fgNameLabel.text = b.name;
            cell.containerNameLabel.text = b.name;
            
            cell.containerPhoneButton.setTitle(b.phone, for: UIControlState.normal)
            
            cell.fgNumberLabel.text = "#"+String(describing:indexPath.row+1)
            
            // set the image
            if(b.bestPhoto != ""){
                cell.containerImageView.sd_setImage(with: URL(string: b.bestPhoto))
            } else {
                if(b.photoCount == 0){
                    // set it to some random photo
                } else {
                    cell.containerImageView.sd_setImage(with: URL(string: b.photo_1))
                }
            }
            

            
            // set the photo to be the best photo
            cell.containerImageView.contentMode = UIViewContentMode.scaleAspectFill
            
            if(b.bestPhoto != ""){
                cell.containerImageView.sd_setImage(with: URL(string: b.bestPhoto))
            } else {
                if(b.photoCount == 0){
                    // set it to some random photo 
                } else {
                    cell.containerImageView.sd_setImage(with: URL(string: b.photo_1))
                }
            }
            
            // set the rating
            if(b.rating.value != nil){
                cell.fgRatingLabel.text = String(describing:Int(b.rating.value!*10))+"/100"
            }
            
            
            // set colors
            cell.fgLeftView.backgroundColor = colors[indexPath.row%4]
            cell.containerTopView.backgroundColor = colors[indexPath.row%4]
            
            cell.containerMenuButton.tag = indexPath.row
            cell.containerImageView.tag = indexPath.row
            
            /*
             1: 0-10
             2: 11-20
             3: 21-35
             4: 36+
             */
            switch b.price {
                case 1:
                    cell.fgPriceLabel.text = "$"
                    cell.containerPriceLabel.text = "Affordable (~10 USD)"
                case 2:
                    cell.fgPriceLabel.text = "$$"
                    cell.containerPriceLabel.text = "Safely Priced (11~20 USD)"
                case 3:
                    cell.fgPriceLabel.text = "$$$"
                    cell.containerPriceLabel.text = "Expensive (21~35 USD)"
                case 4:
                    cell.fgPriceLabel.text = "$$$$"
                    cell.containerPriceLabel.text = "Fancy Fancy (~36 USD)"
                default:
                    cell.fgPriceLabel.text = "N/A"
                    cell.containerPriceLabel.text = "N/A"
            }
            
            cell.containerLikeDescriptionLabel.text = String(describing:b.likes) + " people liked this place"
            if(b.category == "Cafés"){
                cell.fgCategoryLabel.text = "Cafe"
            } else{
                cell.fgCategoryLabel.text = b.category
            }
            
            
        }
    }
    
    func refresh(){
        if let lat = UserDefaults.standard.string(forKey:"lat"){
            if let lon = UserDefaults.standard.string(forKey:"lon"){
                var loc = CLLocationCoordinate2D();
                loc.latitude = Double(lat)!;
                loc.longitude = Double(lon)!;
                FourSquareManager.sharedInstance.search(ll: loc, limit: 20,category: nil, radius: "10000",mapview: nil, tableView: self.tableView,refreshControl: self.refreshControl, removeAllEntries: true)
            }
        }
        
    }
    
    

}
