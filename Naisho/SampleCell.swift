//
//  SimpleCell.swift
//  Naisho
//
//  Created by cao on 2017/04/13.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import FoldingCell
import Mapbox

class SampleCell: FoldingCell {
    
    var businessName = "";
    var businessNumber = 0;
    
    @IBOutlet weak var fgNumberLabel: UILabel!
    @IBOutlet weak var fgScoreLabel: UILabel!
    @IBOutlet weak var fgNameLabel: UILabel!
    @IBOutlet weak var fgCategoryLabel: UILabel!
    @IBOutlet weak var fgPriceLabel: UILabel!
    @IBOutlet weak var fgRatingLabel: UILabel!
    @IBOutlet weak var fgDistanceLabel: UILabel!
    @IBOutlet weak var fgLeftView: UIView!
    @IBOutlet weak var OpenMenuTextView: UITextView!
    
    
    @IBOutlet weak var containerImageView: UIImageView!
    @IBOutlet weak var containerMapView: MGLMapView!
    @IBOutlet weak var containerPriceLabel: UILabel!
    @IBOutlet weak var containerDistanceLabel: UILabel!
    @IBOutlet weak var containerGoButton: UIButton!
    @IBOutlet weak var containerLikeDescriptionLabel: UILabel!
    @IBOutlet weak var containerNameLabel: UILabel!
    @IBOutlet weak var containerTopView: UIView!
    
    @IBOutlet weak var containerPhoneTextView: UITextView!
    @IBOutlet weak var containerMenuTextView: UITextView!
    
    
    
    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        
        backgroundColor = UIColor.clear
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType)-> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    @IBAction func OnClickGoButton(_ sender: Any) {
    }
    
    
}
