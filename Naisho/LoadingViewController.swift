//
//  LoadingViewController.swift
//  Naisho
//
//  Created by cao on 2017/03/29.
//  Copyright © 2017 JustACoin. All rights reserved.
//

import UIKit
import BAFluidView

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //アニメーションのViewを生成
        let animeView = BAFluidView(frame: self.view.frame)
        //波の高さを設定(0~1.0)
        animeView.fill(to: 1.0)
        //波の境界線の色
        animeView.strokeColor = .white
        //波の色
        animeView.fillColor = UIColor(red: 0.274, green: 0.288, blue: 0.297, alpha: 1.0)
        //アニメーション開始（コメントアウトしてもアニメーションされる）
        animeView.startAnimation()
        self.view.addSubview(animeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
