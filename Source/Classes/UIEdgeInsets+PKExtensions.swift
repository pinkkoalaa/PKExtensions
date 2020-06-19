//
//  UIEdgeInsets+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/6/19.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    
    var vertical: CGFloat {
        return top + bottom
    }

    var horizontal: CGFloat {
        return left + right
    }

}
