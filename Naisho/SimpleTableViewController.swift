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

class SimpleTableViewController: UITableViewController {

    private var cellHeights: [CGFloat] = []
    
    private let kCloseCellHeight: CGFloat = 164 //150+14
    private let kOpenCellHeight: CGFloat = 466  //450+16
    
    private let cellCount = RealmManager.sharedInstance.getTotalNumber()
    
    let colors = [UIColor(red:0.72, green:0.20, blue:0.39, alpha:1.0),
                  UIColor(red:0.51, green:0.91, blue:0.26, alpha:1.0),
                  UIColor(red:0.20, green:0.60, blue:0.72, alpha:1.0),
                  UIColor(red:0.92, green:0.48, blue:0.26, alpha:1.0)]
    
    
    
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
            print(indexPath.row)
            cell.fgNameLabel.text = b.name;
            cell.containerNameLabel.text = b.name;
            //cell.fgScoreLabel.text = String(describing:Int(b.rating.value!*10))
            
            // set colors
            cell.fgLeftView.backgroundColor = colors[indexPath.row%4]
            cell.containerTopView.backgroundColor = colors[indexPath.row%4]
        }
    }

}
