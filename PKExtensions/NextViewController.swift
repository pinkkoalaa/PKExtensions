//
//  NextViewController.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/23.
//  Copyright © 2020 Pink Koala. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        view.pk.beginIndicatorLoading()
        // Do any additional setup after loading the view.
//        var useImage = UIImage(named: "jiazaizhong")
//        var useImage = UIImage(named: "guanbi")
        var useImage = UIImage(named: "jiazaizhong的副本")
        
        useImage = useImage?.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView()
        imgView.tintColor = .red
        imgView.image = useImage
        imgView.backgroundColor = .white
        imgView.frame = CGRect.init(x: 100, y: 200, width: 40, height: 40)
        view.addSubview(imgView)
        
        
        
        view.pk.showToast(message: "正在加载", image: UIImage(named: "jiazaizhong的副本"), isSpin: true, layout: .left, position: .center(offset: 0))
        Timer.pk.gcdAsyncAfter(delay: 1) {
            
            self.view.pk.hideToast()
            self.view.pk.showToast(message: "加载成功", image: UIImage(named: "shibai"), layout: .left, position: .center(offset: 0))
        }
        
    }
    

    func mykiopp()  {
        
    }
}
