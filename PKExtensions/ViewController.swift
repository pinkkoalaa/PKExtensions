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
    }

}

