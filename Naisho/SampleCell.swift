//
//  SimpleCell.swift
//  Naisho
//
//  Created by cao on 2017/04/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import FoldingCell

class SampleCell: FoldingCell {
    
    var businessName = "";
    var businessNumber = 0;
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
}
