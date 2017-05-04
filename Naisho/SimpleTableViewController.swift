//
//  SimpleTableViewController.swift
//  Naisho
//
//  Created by cao on 2017/04/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import FoldingCell
import KCFloatingActionButton
import SDWebImage
import MapboxDirections
import Mapbox

class SimpleTableViewController: UITableViewController {

    private var cellHeights: [CGFloat] = []
    
    private let kCloseCellHeight: CGFloat = 164 //150+14
    private let kOpenCellHeight: CGFloat = 466  //450+16
    
    private let cellCount = RealmManager.sharedInstance.getTotalNumber()
    
    let colors = [UIColor(red:0.72, green:0.20, blue:0.39, alpha:1.0),
                  UIColor(red:0.51, green:0.91, blue:0.26, alpha:1.0),
                  UIColor(red:0.20, green:0.60, blue:0.72, alpha:1.0),
                  UIColor(red:0.92, green:0.48, blue:0.26, alpha:1.0)]
    
    private let directions = Directions(accessToken: "pk.eyJ1Ijoidml4YWVyIiwiYSI6ImNpczBneDM0cjAzYjUyenA4eXV1N2Zpb2UifQ.D2L9Dd674rBGVuallWx3RQ")
    
    private let locationManager = LocationManager.sharedInstance;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...cellCount {
            cellHeights.append(kCloseCellHeight)
        }
        
        
        let fab = KCFloatingActionButton()
        fab.buttonColor = UIColor.white
        fab.addItem("Settings", icon: UIImage(named: "settings")!)
        fab.addItem("Main", icon: UIImage(named: "home")!, handler: { item in
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "Main") as! MainViewController
            self.present(nextView, animated: false, completion: nil)
            fab.close()
        })
        
        self.view.addSubview(fab)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
            
            if cell.containerMapView.annotations?.isEmpty == false{
                for a in cell.containerMapView.annotations!{
                    cell.containerMapView.removeAnnotation(a)
                }
            }
            
            
            let point = MGLPointAnnotation()
            point.coordinate = CLLocationCoordinate2D(latitude: b.lat, longitude: b.lon)
            point.title = b.name
            cell.containerMapView.addAnnotation(point)
            
            let lat = Double(UserDefaults.standard.string(forKey:"lat")!)!;
            let lon = Double(UserDefaults.standard.string(forKey:"lon")!)!;
            
            let waypoints = [
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon), name: "Start Position"),
                Waypoint(coordinate: CLLocationCoordinate2D(latitude: b.lat, longitude: b.lon), name: b.name),
                ]
            let options = RouteOptions(waypoints: waypoints, profileIdentifier: .automobileAvoidingTraffic)
            options.includesSteps = true
            
            _ = directions.calculate(options) { (waypoints, routes, error) in
                guard error == nil else {
                    print("Error calculating directions: \(error!)")
                    return
                }
                
                if let route = routes?.first, let leg = route.legs.first {
                    
                    print("Route via \(leg):")
                    
                    let distanceFormatter = LengthFormatter()
                    let formattedDistance = distanceFormatter.string(fromMeters: route.distance)
                    
                    let formatter = DateComponentsFormatter()
                    formatter.unitsStyle = .short
                    formatter.allowedUnits = [.minute]
                    let formattedTravelTime = formatter.string(from: route.expectedTravelTime)
                    
                    print("Distance: \(formattedDistance); ETA: \(formattedTravelTime!)")
                    
                    cell.fgDistanceLabel.text = "~"+formattedTravelTime!
                    cell.containerDistanceLabel.text = "~" + formattedTravelTime!
                    
                    for step in leg.steps {
                        print("\(step.instructions)")
                        let formattedDistance = distanceFormatter.string(fromMeters: step.distance)
                        print("— \(formattedDistance) —")
                    }
                    
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
            if(b.rating.value != nil){
                cell.fgRatingLabel.text = String(describing:Int(b.rating.value!*10))+"/100"
            }
            
            cell.containerPhoneTextView.text = b.phone 
            
            
            cell.fgNumberLabel.text = "#"+String(describing:indexPath.row+1)
            
            let u = RealmManager.sharedInstance.getURLOn(index: indexPath.row, urlIndex: 1)
            if (String(describing: u) != "" && u != nil){
                cell.containerImageView.sd_setImage(with: u)
                cell.containerImageView.contentMode = UIViewContentMode.scaleAspectFill
            }
            
            // set colors
            cell.fgLeftView.backgroundColor = colors[indexPath.row%4]
            cell.containerTopView.backgroundColor = colors[indexPath.row%4]
            
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
                    cell.containerPriceLabel.text = "Damn! (~36 USD)"
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
    
    func makePhoneCall(textField: UITextField) {
        // user touch field
    }

}
