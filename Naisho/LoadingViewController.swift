//
//  LoadingViewController.swift
//  Naisho
//
//  Created by cao on 2017/03/29.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import BAFluidView
import CoreLocation

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //アニメーションのViewを生成
        let animeView = BAFluidView(frame: self.view.frame,startElevation: 0.3)!
        //波の高さを設定(0~1.0)
        animeView.fill(to: 1.0)
        //波の境界線の色
        animeView.strokeColor = .white
        //波の色
        animeView.fillColor = UIColor(red: 0.274, green: 0.288, blue: 0.297, alpha: 1.0)
        //アニメーション開始（コメントアウトしてもアニメーションされる
        animeView.startAnimation()
        self.view.addSubview(animeView)
        
        // Wait for 4 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
            let storyboard: UIStoryboard = self.storyboard!
            let nextView = storyboard.instantiateViewController(withIdentifier: "TabBar") as! UITabBarController
            self.present(nextView, animated: false, completion: nil)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
