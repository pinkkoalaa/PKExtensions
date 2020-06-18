//
//  ViewController.swift
//  PKExtensions
//
//  Created by ahong on 2020/4/1.
//  Copyright © 2020 Pink Koala. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let array = ["9", "2", "7", "5", "3"]
        let value = array.pk.maximin({ Int($0)! })
        print("max is: \(value!.max) \nmin is: \(value!.min)")
        
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.orange.cgColor
        layer.strokeColor = UIColor.blue.cgColor
        layer.lineWidth = 1
        view.layer.addSublayer(layer)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 20, y: 20))
        path.addLine(to: CGPoint(x: 50, y: 50))
        path.pk.addRect(CGRect(x: 50, y: 50, width: 100, height: 50))
        layer.path = path.cgPath
        
        layer.frame = CGRect(x: 50, y: 150, width: 300, height: 200)
        layer.backgroundColor = UIColor.gray.cgColor
        
        let values = "56.878"
        
        let sd = values.pk.toCGFloat()
        print("fls is: \(sd ?? 0)")
        
        colorView()
    }
    
    func colorView() {
        let aView = UIView()
        aView.backgroundColor = .white
        aView.frame = CGRect.init(x: 50, y: 400, width: 200, height: 60)
        aView.layer.cornerRadius = 30
        
        view.addSubview(aView)
        aView.pk.addShadow(radius: 10, opacity: 0.5, color: .gray)
    }

}

