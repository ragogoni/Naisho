//
//  MainCell.swift
//  Naisho
//
//  Created by cao on 2017/04/02.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // rating Images for bananas
    @IBOutlet weak var ratingImage_1: UIImageView!
    @IBOutlet weak var ratingImage_2: UIImageView!
    @IBOutlet weak var ratingImage_3: UIImageView!
    @IBOutlet weak var ratingImage_4: UIImageView!
    @IBOutlet weak var ratingImage_5: UIImageView!
    
    var ratings:[UIImageView] = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ratings.append(ratingImage_1)
        ratings.append(ratingImage_2)
        ratings.append(ratingImage_3)
        ratings.append(ratingImage_4)
        ratings.append(ratingImage_5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // rating is from 0.0 to 10.0 inclusive
    func setRating(rating:Double){
        var temp:Double = rating
        for i in 0...4{
            if(temp >= 2.0){
                self.ratings[i].image = UIImage(named: "bananas")
            } else if (temp < 2.0 && temp >= 1.0){
                self.ratings[i].image = UIImage(named: "banana")
            } else {
                self.ratings[i].isHidden = true;
            }
            temp -= 2.0;
        }
    }
    
    // set the main image
    func setMainImage(urlString:String){
        let url = URL(string: urlString)
        if let data = NSData(contentsOf: url!) {
            self.ImageView.image = UIImage(data: data as Data)
        }
    }
    
    // set the name of the cell
    func setName(name:String){
        self.nameLabel.text = name;
    }
    
    // set the description of the cell
    func setDesc(desc:String){
        self.descriptionLabel.text = desc;
    }
    

}
