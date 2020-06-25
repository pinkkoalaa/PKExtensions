//
//  CALayer+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKLayerExtensions where Base: CALayer {
    
    /// 删除layer的所有子图层
    func removeAllSublayers() {
        while base.sublayers?.count ?? 0 > 0 {
            base.sublayers?.last?.removeFromSuperlayer()
        }
    }
    
    /// 返回对当前Layer的截图
    func screenshots() -> UIImage? {
        guard base.bounds.size.pk.isValid else { return nil }
        UIGraphicsBeginImageContextWithOptions(base.frame.size, false, UIScreen.main.scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        base.render(in: context)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

public extension PKLayerExtensions where Base: CALayer {
    
    /// 禁止layer的隐式动画
    static func disableActions<T: CALayer>(layer: T, work: ((T) -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        work?(layer)
        CATransaction.commit()
    }
    
    /// 为layer添加fade动画，当图层内容变化时将以淡入淡出动画使内容渐变
    func fade(_ duration: TimeInterval = 0.25, curve: CAMediaTimingFunctionName) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: curve)
        animation.type = .fade
        animation.duration = duration
        base.add(animation, forKey: "_pkExtensions.anim.fade")
    }
    
    /// 为layer添加自旋转动画
    func spin(_ duration: TimeInterval = 0.75, curve: CAMediaTimingFunctionName = .linear, clockwise: Bool = true) {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = (clockwise ? CGFloat.pi : -CGFloat.pi) * 2
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        animation.fillMode = .forwards
        animation.timingFunction = CAMediaTimingFunction(name: curve)
        base.add(animation, forKey: "_pkExtensions.anim.spin")
    }
    
    /// 为layer添加透明度变化动画
    func opacity(from origin: Float,
                 to target: Float,
                 duration: TimeInterval = 0.5,
                 completion: ((Bool) -> Void)? = nil) {
        let basic = CABasicAnimation(keyPath: "opacity")
        basic.fromValue = origin
        basic.toValue = target
        basic.duration = duration
        basic.fillMode = .forwards
        basic.isRemovedOnCompletion = false
        base.add(basic, forKey: nil)
        
        Timer.pk.gcdAsyncAfter(delay: duration) { completion?(true) }
    }
}

public extension PKLayerExtensions where Base: CAShapeLayer {

    /// 自定义shapeLayer路径改变动画
    func path(from origin: CGPath?,
              to target: CGPath?,
              duration: TimeInterval = 0.5,
              completion: ((Bool) -> Void)? = nil) {
        guard
            let fromPath = origin,
            let toPath = target else { return }
        
        let basic = CABasicAnimation(keyPath: "path")
        basic.fromValue = fromPath
        basic.toValue = toPath
        basic.duration = duration
        basic.fillMode = .forwards
        basic.isRemovedOnCompletion = false
        base.add(basic, forKey: nil)
        
        Timer.pk.gcdAsyncAfter(delay: duration) { completion?(true) }
    }
}

public struct PKLayerExtensions<Base> {
    var base: Base
    fileprivate init(_ base: Base) { self.base = base }
}

public protocol PKLayerExtensionsCompatible {}

public extension PKLayerExtensionsCompatible {
    static var pk: PKLayerExtensions<Self>.Type { PKLayerExtensions<Self>.self }
    var pk: PKLayerExtensions<Self> { get{ PKLayerExtensions(self) } set{} }
}

extension CALayer: PKLayerExtensionsCompatible {}

public extension CALayer {
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        } set(value) {
            self.frame = CGRect(x: value, y: top, width: width, height: height)
        }
    }

    var right: CGFloat {
        get {
            return left + width
        } set(value) {
            left = value - width
        }
    }

    var top: CGFloat {
        get {
            return self.frame.origin.y
        } set(value) {
            self.frame = CGRect(x: left, y: value, width: width, height: height)
        }
    }

    var bottom: CGFloat {
        get {
            return top + height
        } set(value) {
            top = value - height
        }
    }

    var width: CGFloat {
        get {
            return self.frame.size.width
        } set(value) {
            self.frame = CGRect(x: left, y: top, width: value, height: height)
        }
    }

    var height: CGFloat {
        get {
            return self.frame.size.height
        } set(value) {
            self.frame = CGRect(x: left, y: top, width: width, height: value)
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }

    var centerX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width * 0.5
        } set(value) {
            var frame = self.frame
            frame.origin.x = value - frame.size.width * 0.5
            self.frame = frame
        }
    }

    var centerY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height * 0.5;
        } set(value) {
            var frame = self.frame
            frame.origin.y = value - frame.size.height * 0.5;
            self.frame = frame
        }
    }
}
