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
        let gvManager = GradientViewManager(color1: UIColor(red:0.29, green:0.94, blue:1.00, alpha:1.0),color2: UIColor(red:0.26, green:0.43, blue:0.54, alpha:1.0),view: self.view);
        let gradientView = gvManager.getGradientView();
        self.view = gradientView;
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
