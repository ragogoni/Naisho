//
//  Gradient.swift
//  Sephiri
//
//  Created by cao on 2017/03/08.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import Foundation
import UIKit

class GradientViewManager:NSObject{
    
    let gradientView = UIView()
    
    init(color1 :UIColor, color2:UIColor, view : UIView) {
        gradientView.frame = view.bounds;
        let gradient = CAGradientLayer();
        gradient.frame = view.bounds;
        gradient.locations = [0,1];
        gradient.colors = [color1.cgColor,color2.cgColor];
        gradientView.layer.insertSublayer(gradient, at: 0);
    }
    
    func getGradientView() -> UIView{
        return self.gradientView;
    }
}
