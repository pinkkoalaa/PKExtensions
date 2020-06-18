//
//  UIBezierPath+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/6/17.
//  Copyright © 2020 zhanghao. All rights reserved.
//

import UIKit

public extension PKBezierPathExtensions {
    
    enum NGonOrigin {
        case top, bottom, left, right
    }
    
    /// 绘制正多边形
    ///
    /// - Parameters:
    ///   - center: 圆心点坐标 (正多形的外接圆)
    ///   - radius: 正多边形的半径
    ///   - sides: 边数 (至少为3)
    ///   - origin: 起始绘制点
    ///
    /// - Returns: 正多边形路径
    static func NGon(center: CGPoint, radius: CGFloat, sides: Int, origin: NGonOrigin)  -> UIBezierPath {
        func start() -> CGPoint {
            switch origin {
            case .top:
                return CGPoint(x: center.x, y: center.y - radius)
            case .bottom:
                return CGPoint(x: center.x, y: center.y + radius)
            case .left:
                return CGPoint(x: center.x - radius, y: center.y)
            case .right:
                return CGPoint(x: center.x + radius, y: center.y)
            }
        }
        
        func link(_ radian: CGFloat) -> CGPoint {
            switch origin {
            case .top:
                return CGPoint(x: center.x + radius * sin(radian), y: center.y - radius * cos(radian))
            case .bottom:
                return CGPoint(x: center.x + radius * sin(radian), y: center.y + radius * cos(radian))
            case .left:
                return CGPoint(x: center.x - radius * cos(radian), y: center.y + radius * sin(radian))
            case .right:
                return CGPoint(x: center.x + radius * cos(radian), y: center.y + radius * sin(radian))
            }
        }
        
        let count = max(3, sides)
        let path = UIBezierPath()
        path.move(to: start())
        for i in 0...count {
            let radian: CGFloat = .pi * CGFloat(2 * i) / CGFloat(count)
            path.addLine(to: link(radian))
        }
        path.close()
        return path
    }
    
    /// 添加矩形框
    func addRect(_ rect: CGRect) {
        base.move(to: rect.origin)
        base.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        base.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        base.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        base.close()
    }
}

public struct PKBezierPathExtensions {
    fileprivate static var Base: UIBezierPath.Type { UIBezierPath.self }
    fileprivate var base: UIBezierPath
    fileprivate init(_ base: UIBezierPath) { self.base = base }
}

public extension UIBezierPath {
    var pk: PKBezierPathExtensions { PKBezierPathExtensions(self) }
    static var pk: PKBezierPathExtensions.Type { PKBezierPathExtensions.self }
}
