//
//  UIScrollView+PKExtensions.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/21.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UIScrollView {

    /// 获取整个滚动视图快照 (UIScrollView滚动内容区)
    func snapshot() -> UIImage? {
        // Original Source: https://gist.github.com/thestoics/1204051
        UIGraphicsBeginImageContextWithOptions(base.contentSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        let previousFrame = base.frame
        base.frame = CGRect(origin: base.frame.origin, size: base.contentSize)
        base.layer.render(in: context)
        base.frame = previousFrame
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
