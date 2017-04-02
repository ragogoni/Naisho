//
//  CustomScrollableView.swift
//  Naisho
//
//  Created by cao on 2017/04/02.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit

class CustomScrollableView: UIView {
    
    
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var ratingImage_1: UIImageView!
    @IBOutlet weak var ratingImage_2: UIImageView!
    @IBOutlet weak var ratingImage_3: UIImageView!
    @IBOutlet weak var ratingImage_4: UIImageView!
    @IBOutlet weak var ratingImage_5: UIImageView!
    
    
    // init code
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    // init xib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        comminInit()
    }
    
    
    private func comminInit() {
        
        // Load Custom Scrollable View
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomScrollableView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
        
        // Add Constraints
        view.translatesAutoresizingMaskIntoConstraints = false
        let bindings = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                                      metrics:nil,
                                                                      views: bindings))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                      options:NSLayoutFormatOptions(rawValue: 0),
                                                                      metrics:nil,
                                                                      views: bindings))
    }
}

