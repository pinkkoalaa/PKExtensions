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
    
    /// 图片颜色 (设置nil不做任何修改)
    public var imageColor: UIColor? = .white
    
    /// 文本字体
    public var messageFont: UIFont = .systemFont(ofSize: 15.0)
    
    /// 文本对齐样式
    public var messageAlignment: NSTextAlignment = .left
    
    /// 文本最大行数 (默认无限制)
    public var messageNumberOfLines: Int = 0
    
    /// 文本最大宽度限制
    public var messageLayoutMaxWidth: CGFloat = 200
    
    /// 图片尺寸
    public var imageSize = CGSize(width: 20, height: 20)
    
    /// Toast淡入淡出动画时间
    public var fadeDuration: TimeInterval = 0
    
    /// 圆角半径
    public var cornerRadius: CGFloat = 2
    
    /// 子视图间距
    public var interitemSpacing: CGFloat = 10
    
    /// 内容边缘留白
    public var paddingInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
}

public extension PKViewExtensions where Base: UIView {
    
    /// Toast子视图布局
    enum ToastLayout: Int {
        case top, left, bottom, right
    }
    
    /// Toast显示位置
    enum ToastPosition {
        case top(offset: CGFloat)
        case center(offset: CGFloat)
        case bottom(offset: CGFloat)
    }
    
    /// 图片文本样式Toast
    func showToast(message: String?,
                   image: UIImage?,
                   rotateAnimated: Bool = false,
                   layout: ToastLayout = .left,
                   position: ToastPosition = .center(offset: 0),
                   style: PKToastStyle = .shared) {
        if let msg = message, let img = image {
            return _perfectToast(message: msg, image: img, rotateAnimated: rotateAnimated, layout: layout, position: position, style: style)
        }
        
        if let msg = message {
            return _messageToast(message: msg, position: position, style: style)
        }
        
        if let img = image {
            return _imageToast(image: img, rotateAnimated: rotateAnimated, position: position, style: style)
        }
    }
    
    /// 仅图片样式Toast
    func showToast(image: UIImage?, rotateAnimated: Bool = false, position: ToastPosition = .center(offset: 0), style: PKToastStyle = .shared) {
        guard let img = image else { return }
        _imageToast(image: img, rotateAnimated: rotateAnimated, position: position, style: style)
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
        let contentView = UIView()
        contentView.isUserInteractionEnabled = false
        base.addSubview(contentView)
        base.pk_activeToasts.add(contentView)
        
        let hud = UIView()
        hud.backgroundColor = style.backgroundColor
        hud.layer.cornerRadius = style.cornerRadius
        hud.clipsToBounds = true
        contentView.addSubview(hud)
        
        let label = UILabel()
        label.text = message
        label.textColor = style.messageColor
        label.font = style.messageFont
        label.numberOfLines = style.messageNumberOfLines
        label.textAlignment = style.messageAlignment
        hud.addSubview(label)
        
        contentView.pk.makeConstraints { (make) in
            if let scrollView = self.base as? UIScrollView {
                let insets = scrollView.contentInset
                make.left.equalToSuperview().offset(-insets.left)
                make.right.equalToSuperview().offset(insets.right)
                make.top.equalToSuperview().offset(-insets.top)
                make.bottom.equalToSuperview().offset(insets.bottom)
                make.size.equalToSuperview()
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        label.pk.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        hud.pk.makeConstraints { (make) in
            let insets = style.paddingInsets
            make.left.equalTo(label).offset(-insets.left)
            make.right.equalTo(label).offset(insets.right)
            make.top.equalTo(label).offset(-insets.top)
            make.bottom.equalTo(label).offset(insets.bottom)
        }
        
        _adjustToast(hud, position)
        
        hud.alpha = 0
        UIView.animate(withDuration: style.fadeDuration, delay: 0, options: .curveEaseOut, animations: {
            hud.alpha = 1.0
        })
    }
    
    private func _imageToast(image: UIImage, rotateAnimated: Bool, position: ToastPosition, style: PKToastStyle) {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = false
        base.addSubview(contentView)
        base.pk_activeToasts.add(contentView)
        
        let hud = UIView()
        hud.backgroundColor = style.backgroundColor
        hud.layer.cornerRadius = style.cornerRadius
        hud.clipsToBounds = true
        contentView.addSubview(hud)
        
        let imgView = UIImageView()
        if let tintColor = style.imageColor {
            imgView.image = image.withRenderingMode(.alwaysTemplate)
            imgView.tintColor = tintColor
        } else {
            imgView.image = image
        }
        hud.addSubview(imgView)
            
        contentView.pk.makeConstraints { (make) in
            if let scrollView = self.base as? UIScrollView {
                let insets = scrollView.contentInset
                make.left.equalToSuperview().offset(-insets.left)
                make.right.equalToSuperview().offset(insets.right)
                make.top.equalToSuperview().offset(-insets.top)
                make.bottom.equalToSuperview().offset(insets.bottom)
                make.size.equalToSuperview()
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        imgView.snp.makeConstraints { (make) in
            make.size.equalTo(style.imageSize)
            make.center.equalToSuperview()
        }
        
        hud.pk.makeConstraints { (make) in
            let insets = style.paddingInsets
            make.left.equalTo(imgView).offset(-insets.left)
            make.right.equalTo(imgView).offset(insets.right)
            make.top.equalTo(imgView).offset(-insets.top)
            make.bottom.equalTo(imgView).offset(insets.bottom)
        }
        
        _adjustToast(hud, position)
        
        if rotateAnimated {
            imgView.layer.pk.rotateAnimation()
        }
        
        hud.alpha = 0
        UIView.animate(withDuration: style.fadeDuration, delay: 0, options: .curveEaseOut, animations: {
            hud.alpha = 1.0
        })
    }
    
    private func _perfectToast(message: String, image: UIImage, rotateAnimated: Bool, layout: ToastLayout, position: ToastPosition, style: PKToastStyle) {
        let contentView = UIView()
        contentView.isUserInteractionEnabled = false
        base.addSubview(contentView)
        base.pk_activeToasts.add(contentView)
        
        let hud = UIView()
        hud.backgroundColor = style.backgroundColor
        hud.layer.cornerRadius = style.cornerRadius
        hud.clipsToBounds = true
        contentView.addSubview(hud)
        
        let button = IngenuityButton(type: .custom)
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        button.layer.cornerRadius = style.cornerRadius
        button.imageSpecifiedSize = style.imageSize
        button.imageAndTitleSpacing = style.interitemSpacing
        button.imagePosition = IngenuityButton.ImagePosition(rawValue: layout.rawValue)!
        button.setTitle(message, for: .normal)
        button.setTitleColor(style.messageColor, for: .normal)
        button.titleLabel?.font = style.messageFont
        button.titleLabel?.numberOfLines = style.messageNumberOfLines
        button.titleLabel?.textAlignment = style.messageAlignment
        button.titleLabel?.preferredMaxLayoutWidth = style.messageLayoutMaxWidth
        button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = style.imageColor
        hud.addSubview(button)
    
        contentView.pk.makeConstraints { (make) in
            if let scrollView = self.base as? UIScrollView {
                let insets = scrollView.contentInset
                make.left.equalToSuperview().offset(-insets.left)
                make.right.equalToSuperview().offset(insets.right)
                make.top.equalToSuperview().offset(-insets.top)
                make.bottom.equalToSuperview().offset(insets.bottom)
                make.size.equalToSuperview()
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        button.pk.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        hud.pk.makeConstraints { (make) in
            let insets = style.paddingInsets
            make.left.equalTo(button).offset(-insets.left)
            make.right.equalTo(button).offset(insets.right)
            make.top.equalTo(button).offset(-insets.top)
            make.bottom.equalTo(button).offset(insets.bottom)
        }
        
        _adjustToast(hud, position)
        
        if rotateAnimated {
            button.imageView?.layer.pk.rotateAnimation()
        }
        
        hud.alpha = 0
        UIView.animate(withDuration: style.fadeDuration, delay: 0, options: .curveEaseOut, animations: {
            hud.alpha = 1.0
        })
    }
    
    private func _adjustToast(_ toast: UIView, _ position: ToastPosition) {
        switch position {
        case .top(offset: let value):
            toast.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(value)
            }
        case .center(offset: let value):
            toast.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(value)
            }
        case .bottom(offset: let value):
            toast.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(value)
            }
        }
    }
    
    private func _hideToast(_ toast: UIView) {
        guard base.pk_activeToasts.contains(toast) else { return }
        UIView.animate(withDuration: PKToastStyle.shared.fadeDuration, delay: 0, options: [.curveEaseIn, .beginFromCurrentState], animations: {
            toast.alpha = 0
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
