//
//  BasicViewController.swift
//  Sephiri
//
//  Created by cao on 2017/03/08.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit

class BasicViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // add gradient
        let gvManager = GradientViewManager(color1: UIColor(red:0.79, green:0.79, blue:0.79, alpha:1.0),color2: UIColor(red:0.87, green:0.87, blue:0.87, alpha:1.0),view: self.view);
        let gradientView = gvManager.getGradientView();
        self.view.addSubview(gradientView)
        self.view.sendSubview(toBack: gradientView)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
