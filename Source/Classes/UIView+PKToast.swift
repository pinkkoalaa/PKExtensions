//
//  UIView+PKToast.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/23.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public class PKToastStyle {
    
    /// PKToastStyle单例实例
    public static let shared = PKToastStyle()
    
    /// 背景色
    public var backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.8)
    
    /// 文本颜色
    public var messageColor: UIColor = .white
    
    /// 图片颜色 (若为nil则使用图片原色)
    public var imageColor: UIColor? = .white
    
    /// 文本字体
    public var messageFont: UIFont = .systemFont(ofSize: 15.0)
    
    /// 文本对齐样式
    public var messageAlignment: NSTextAlignment = .left
    
    /// 文本最大行数 (默认无限制)
    public var messageNumberOfLines: Int = 0
    
    /// 文本最大宽度限制
    public var messageLayoutMaxWidth: CGFloat = 180
    
    /// 文本最大高度限制
    public var messageLayoutMaxHeight: CGFloat = 400
    
    /// 图片尺寸
    public var imageSize = CGSize(width: 20, height: 20)
    
    /// Toast淡入淡出动画时间
    public var fadeDuration: TimeInterval = 0
    
    /// 圆角半径
    public var cornerRadius: CGFloat = 2
    
    /// 子视图间距
    public var lineSpacing: CGFloat = 10
    
    /// 内容边缘留白
    public var paddingInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
}

public extension PKViewExtensions where Base: UIView {
    
    /// Toast子视图布局
    enum ToastLayout {
        case top, left, bottom, right
    }
    
    /// Toast位置
    enum ToastPosition {
        case top(offset: CGFloat)
        case center(offset: CGFloat)
        case bottom(offset: CGFloat)
    }
    
    /// 图片文本样式Toast
    func showToast(message: String?,
                   image: UIImage?,
                   isSpin: Bool = false,
                   layout: ToastLayout = .left,
                   position: ToastPosition = .center(offset: 0),
                   style: PKToastStyle = .shared) {
        if let msg = message, let img = image {
            return _perfectToast(message: msg, image: img, isSpin: isSpin, layout: layout, position: position, style: style)
        }
        
        if let msg = message {
            return _messageToast(message: msg, position: position, style: style)
        }
        
        if let img = image {
            return _imageToast(image: img, isSpin: isSpin, position: position, style: style)
        }
    }
    
    /// 仅图片样式Toast
    func showToast(image: UIImage?, isSpin: Bool = false, position: ToastPosition = .center(offset: 0), style: PKToastStyle = .shared) {
        guard let img = image else { return }
        _imageToast(image: img, isSpin: isSpin, position: position, style: style)
    }
    
    /// 仅文本样式Toast
    func showToast(message: String?, position: ToastPosition = .center(offset: 0), style: PKToastStyle = .shared) {
        guard let msg = message else { return }
        _messageToast(message: msg, position: position, style: style)
    }
    
    /// 隐藏Toast
    func hideToast() {
        guard let activeToast = base.pk_activeToasts.firstObject as? UIView else { return }
        _hideToast(activeToast)
    }
    
    /// 隐藏所有Toast
    func hideAllToasts() {
        base.pk_activeToasts.compactMap { $0 as? UIView } .forEach { _hideToast($0) }
    }
    
    // MARK: - private -
    
    private func _messageToast(message: String, position: ToastPosition, style: PKToastStyle) {
        let label = UILabel()
        label.text = message
        label.textColor = style.messageColor
        label.font = style.messageFont
        label.numberOfLines = style.messageNumberOfLines
        label.textAlignment = style.messageAlignment
        var size = label.sizeThatFits(CGSize(width: style.messageLayoutMaxWidth,
                                                 height: .greatestFiniteMagnitude))
        size.height = min(size.height, style.messageLayoutMaxHeight)
        label.frame = CGRect(origin: .zero, size: size.pk.ceiled())
        
        let hud = UIView()
        hud.backgroundColor = style.backgroundColor
        hud.clipsToBounds = true
        hud.layer.cornerRadius = style.cornerRadius
        let insets = style.paddingInsets
        hud.frame = CGRect(origin: .zero, size: CGSize(width: size.width + insets.left + insets.right,
                                                       height: size.height + insets.top + insets.bottom))
        label.center = CGPoint(x: hud.bounds.width.pk.scaled(0.5), y: hud.bounds.height.pk.scaled(0.5))
        hud.addSubview(label)
        base.addSubview(hud)
        base.pk_activeToasts.add(hud)
        
        hud.alpha = 0
        UIView.animate(withDuration: style.fadeDuration, delay: 0, options: .curveEaseOut, animations: {
            hud.alpha = 1.0
        })
        
        _adjustToast(hud, position)
    }
    
    private func _imageToast(image: UIImage, isSpin: Bool, position: ToastPosition, style: PKToastStyle) {
        let imgView = UIImageView()
        if let tintColor = style.imageColor {
            imgView.image = image.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = tintColor
        } else {
            imgView.image = image
        }
        let size = style.imageSize
        imgView.frame = CGRect(origin: .zero, size: size)
        
        let hud = UIView()
        hud.backgroundColor = style.backgroundColor
        hud.clipsToBounds = true
        hud.layer.cornerRadius = style.cornerRadius
        let insets = style.paddingInsets
        hud.frame = CGRect(origin: .zero, size: CGSize(width: size.width + insets.left + insets.right,
                                                       height: size.height + insets.top + insets.bottom))
        imgView.center = CGPoint(x: hud.bounds.width.pk.scaled(0.5), y: hud.bounds.height.pk.scaled(0.5))
        hud.addSubview(imgView)
        base.addSubview(hud)
        base.pk_activeToasts.add(hud)
        
        if isSpin {
            imgView.layer.pk.spin()
        }
        
        hud.alpha = 0
        UIView.animate(withDuration: style.fadeDuration, delay: 0, options: .curveEaseOut, animations: {
            hud.alpha = 1.0
        })
        
        _adjustToast(hud, position)
    }
    
    private func _perfectToast(message: String,
                               image: UIImage,
                               isSpin: Bool,
                               layout: ToastLayout,
                               position: ToastPosition,
                               style: PKToastStyle) {
        let mssgLabel = UILabel()
        mssgLabel.text = message
        mssgLabel.textColor = style.messageColor
        mssgLabel.font = style.messageFont
        mssgLabel.numberOfLines = style.messageNumberOfLines
        mssgLabel.textAlignment = style.messageAlignment
        var size = mssgLabel.sizeThatFits(CGSize(width: style.messageLayoutMaxWidth,
                                                 height: .greatestFiniteMagnitude))
        size.height = min(size.height, style.messageLayoutMaxHeight)
        mssgLabel.frame = CGRect(origin: .zero, size: size.pk.ceiled())
        
        let imageView = UIImageView()
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = style.imageColor
        imageView.frame = CGRect(origin: .zero, size: style.imageSize)

        let hud = UIView()
        hud.backgroundColor = style.backgroundColor
        hud.clipsToBounds = true
        hud.layer.cornerRadius = style.cornerRadius
        hud.addSubview(mssgLabel)
        hud.addSubview(imageView)
        base.addSubview(hud)
        base.pk_activeToasts.add(hud)
        
        if isSpin {
            imageView.layer.pk.spin()
        }
        
        hud.alpha = 0
        UIView.animate(withDuration: style.fadeDuration, delay: 0, options: .curveEaseOut, animations: {
            hud.alpha = 1.0
        })
    
        let insets = style.paddingInsets
        let lineSpacing = style.lineSpacing
        let imgSize = imageView.bounds.size
        let labSize = mssgLabel.bounds.size
        
        switch layout {
        case .top:
            let hudWidth = max(imgSize.width, labSize.width) + insets.left + insets.right
            let hudHeight = imgSize.height + labSize.height + lineSpacing + insets.top + insets.bottom
            hud.frame = CGRect(origin: .zero, size: CGSize(width: hudWidth, height: hudHeight))
            imageView.center = CGPoint(x: hudWidth.pk.scaled(0.5),
                                       y: insets.top + imgSize.height.pk.scaled(0.5))
            mssgLabel.center = CGPoint(x: hudWidth.pk.scaled(0.5),
                                       y: hudHeight - insets.bottom - labSize.height.pk.scaled(0.5))
        case .left:
            let hudWidth = imgSize.width + labSize.width + lineSpacing + insets.left + insets.right
            let hudHeight = max(imgSize.height, labSize.height) + insets.top + insets.bottom
            hud.frame = CGRect(origin: .zero, size: CGSize(width: hudWidth, height: hudHeight))
            imageView.center = CGPoint(x: insets.left + imgSize.width.pk.scaled(0.5),
                                       y: hudHeight.pk.scaled(0.5))
            mssgLabel.center = CGPoint(x: hudWidth - insets.right - labSize.width.pk.scaled(0.5),
                                       y: hudHeight.pk.scaled(0.5))
        case .bottom:
            let hudWidth = max(imgSize.width, labSize.width) + insets.left + insets.right
            let hudHeight = imgSize.height + labSize.height + lineSpacing + insets.top + insets.bottom
            hud.frame = CGRect(origin: .zero, size: CGSize(width: hudWidth, height: hudHeight))
            mssgLabel.center = CGPoint(x: hudWidth.pk.scaled(0.5),
                                       y: insets.top + labSize.height.pk.scaled(0.5))
            imageView.center = CGPoint(x: hudWidth.pk.scaled(0.5),
                                       y: hudHeight - insets.bottom - imgSize.height.pk.scaled(0.5))
        case .right:
            let hudWidth = imgSize.width + labSize.width + lineSpacing + insets.left + insets.right
            let hudHeight = max(imgSize.height, labSize.height) + insets.top + insets.bottom
            hud.frame = CGRect(origin: .zero, size: CGSize(width: hudWidth, height: hudHeight))
            mssgLabel.center = CGPoint(x: insets.left + labSize.width.pk.scaled(0.5),
                                       y: hudHeight.pk.scaled(0.5))
            imageView.center = CGPoint(x: hudWidth - insets.right - imgSize.width.pk.scaled(0.5),
                                       y: hudHeight.pk.scaled(0.5))
        }
        
        _adjustToast(hud, position)
    }
    
    private func _adjustToast(_ toast: UIView, _ position: ToastPosition) {
        let safe = UIScreen.pk.safeInsets
        switch position {
        case .top(offset: let value):
            toast.center = CGPoint(x: base.bounds.width.pk.scaled(0.5),
                                   y: toast.bounds.height.pk.scaled(0.5) + safe.top + value)
        case .center(offset: let value):
            toast.center = CGPoint(x: base.bounds.width.pk.scaled(0.5),
                                   y: base.bounds.height.pk.scaled(0.5) + value)
        case .bottom(offset: let value):
            toast.center = CGPoint(x: base.bounds.width.pk.scaled(0.5),
                                   y: base.bounds.height - safe.bottom - toast.bounds.height.pk.scaled(0.5) + value)
        }
    }
    
    private func _hideToast(_ toast: UIView) {
        guard base.pk_activeToasts.contains(toast) else { return }
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toast.alpha = 0.0
        }) { _ in
            toast.removeFromSuperview()
            self.base.pk_activeToasts.remove(toast)
        }
    }
}

private var UIViewAssociatedPKToastViewsKey: Void?

private extension UIView {
    var pk_activeToasts: NSMutableArray {
        get {
            if let activeToasts = objc_getAssociatedObject(self, &UIViewAssociatedPKToastViewsKey) as? NSMutableArray {
                return activeToasts
            } else {
                let activeToasts = NSMutableArray()
                objc_setAssociatedObject(self, &UIViewAssociatedPKToastViewsKey, activeToasts, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return activeToasts
            }
        }
    }
}
