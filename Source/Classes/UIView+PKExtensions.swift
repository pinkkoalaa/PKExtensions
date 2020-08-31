//
//  UIView+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKViewExtensions where Base: UIView {
    
    /// 设置视图禁用交互时长
    func disableInteraction(duration: TimeInterval = 0) {
        guard base.isUserInteractionEnabled else { return }
        base.isUserInteractionEnabled = false
        guard duration > 0 else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.base.isUserInteractionEnabled = true
        }
    }
    
    /// 删除视图的所有子视图
    func removeAllSubviews() {
        base.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// 返回视图所在的控制器
    func dependViewController() -> UIViewController? {
        weak var dependResponder: UIResponder? = base
        while dependResponder != nil {
            dependResponder = dependResponder!.next
            if let viewController = dependResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    /// 返回对当前View的截图
    func screenshots() -> UIImage? {
        return base.layer.pk.screenshots()
    }
    
    /// 为视图指定位置添加圆角
    ///
    ///     let aView = UIView()
    ///     aView.pk.addCorner(radius: 5, byRoundingCorners: [.topLeft, .bottomLeft])
    ///     // 注：使用此方法设置圆角，超出父图层部分的子图层将被裁减掉，且在视图得到位置大小后调用生效
    ///     // 若视图必须等Auto Layout算出元件的大小后，再计算cornerRadius，推荐两种写法：
    ///     // 1. 在controller的 viewDidLayoutSubviews() 里计算 cornerRadius
    ///     // 该方法执行时controller内的视图都已按 auto layout 的约束得到位置大小
    ///     // 2. 在自定义view的 layoutSubviews() 里计算 cornerRadius
    ///     // 该方法执行时视图自身和它的子视图都已按 auto layout 的约束得到位置大小
    ///
    /// - Parameters:
    ///   - radius: 圆角半径
    ///   - corners: 添加圆角的位置，默认四周
    func addCorner(radius: CGFloat, byRoundingCorners corners: UIRectCorner = .allCorners) {
        guard base.bounds.size.pk.isValid else { return }
        let path = UIBezierPath(roundedRect: base.bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = base.bounds
        maskLayer.path = path.cgPath
        base.layer.mask = maskLayer
    }
    
    /// 为视图指定位置添加边框线
    ///
    ///     let aView = UIView()
    ///     aView.pk.addBorderLayer(width: 1 / UIScreen.main.scale, color: .red, byRectEdge: [.left, .bottom])
    ///     // 注：在视图得到位置大小后调用生效，同addCorner(:)方法说明
    ///
    /// - Parameters:
    ///   - width: 边框线宽度
    ///   - color: 边框线颜色
    ///   - edges: 添加边框线的位置，默认四周
    func addBorderLayer(width: CGFloat, color: UIColor? = .gray, byRectEdge edges: UIRectEdge = .left) {
        guard base.bounds.size.pk.isValid else { return }
        
        let path = UIBezierPath()
        let centerWidth = width / 2
        if edges.rawValue & UIRectEdge.top.rawValue > 0 {
            path.move(to: CGPoint(x: 0, y: centerWidth))
            path.addLine(to: CGPoint(x: base.bounds.width, y: centerWidth))
        }
        
        if edges.rawValue & UIRectEdge.left.rawValue > 0 {
            path.move(to: CGPoint(x: centerWidth, y: 0))
            path.addLine(to: CGPoint(x: centerWidth, y: base.bounds.height))
        }
        
        if edges.rawValue & UIRectEdge.bottom.rawValue > 0 {
            path.move(to: CGPoint(x: 0, y: base.bounds.height - centerWidth))
            path.addLine(to: CGPoint(x: base.bounds.width, y: base.bounds.height - centerWidth))
        }
         
        if edges.rawValue & UIRectEdge.right.rawValue > 0 {
            path.move(to: CGPoint(x: base.bounds.width - centerWidth, y: 0))
            path.addLine(to: CGPoint(x: base.bounds.width - centerWidth, y: base.bounds.height))
        }
        
        if let lineLayer = base.pk_borderLayer {
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = width
            lineLayer.strokeColor = color?.cgColor
        } else {
            let layer = CAShapeLayer()
            layer.zPosition = 2200
            layer.path = path.cgPath
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = color?.cgColor
            layer.lineWidth = width
            base.layer.addSublayer(layer)
            base.pk_borderLayer = layer
        }
    }
    
    /// 删除视图边框线 (对应-addBorder:方法)dddd
    func removeBorderLayer() {
        base.pk_borderLayer?.removeFromSuperlayer()
        base.pk_borderLayer = nil
    }
    
    /// 为视图添加阴影效果
    ///
    ///     let aView = UIView()
    ///     aView.pk.addShadow(radius: 5, opacity: 0.7, offset: .zero, color: .red)
    ///
    /// - Parameters:
    ///   - radius: 阴影半径
    ///   - opacity: 阴影透明度，取值范围0至1
    ///   - offset: 阴影偏移量，默认CGSize.zero
    ///
    ///            - offset设置为.zero时，可以为四周添加阴影效果
    ///            - offset中的width为正数时，阴影向右偏移，为负数时，向左偏移
    ///            - offset中的height为正数时，阴影向下偏移，为负数时，向上偏移
    ///
    ///   - color: 阴影颜色，默认灰色
    func addShadow(radius: CGFloat, opacity: Float, offset: CGSize = .zero, color: UIColor? = .gray) {
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowOffset = offset
        base.layer.shadowColor = color?.cgColor
    }
    
    /// 通过设置阴影路径为视图添加四周阴影效果，显示效果更加均匀
    ///
    ///     let aView = UIView()
    ///     aView.pk.setShadowPath(radius: 5, opacity: 0.2, color:.gray)
    ///     // 注：在视图得到位置大小后调用生效，同addCorner(:)方法说明
    ///
    /// - Parameters:
    ///   - radius: 阴影半径，默认为5
    ///   - opacity: 阴影透明度，取值范围0至1
    ///   - color: 阴影颜色，默认灰色
    func setShadowPath(radius: CGFloat = 5, opacity: Float, color: UIColor? = .gray) {
        base.layer.shadowRadius = radius
        base.layer.shadowOpacity = opacity
        base.layer.shadowColor = color?.cgColor
        base.layer.shadowOffset = .zero
        
        guard base.bounds.size.pk.isValid else { return }
        let path = UIBezierPath(roundedRect: base.bounds, cornerRadius: base.layer.cornerRadius)
        base.layer.shadowPath = path.cgPath
    }
    
    /// 线性渐变方向
    enum GradientDirection {
        /// 从左到右渐变
        case leftToRight
        /// 从右到左渐变
        case rightToLeft
        /// 从上到下渐变
        case topToBottom
        /// 从下到上渐变
        case bottomToTop
        /// 从左上到右下渐变
        case leftTopToRightBottom
        /// 从左下到右上渐变
        case leftBottomToRightTop
        /// 从右上到左下渐变
        case rightTopToLeftBottom
        /// 从右下到左上渐变
        case rightBottomToLeftTop
    }
    
    /// 为视图添加线性渐变图层
    ///
    ///     let aView = UIView()
    ///     aView.pk.addGradientLayer(colors: [.red, .orange], direction: .leftToRight)
    ///     // 注：在视图得到位置大小后调用生效，同addCorner(:)方法说明
    ///
    /// - Parameters:
    ///   - colors: 渐变颜色数组
    ///   - direction: 渐变方向
    func addGradientLayer(colors: [UIColor?], direction: GradientDirection = .leftToRight) {
        return addGradientLayer(colors: colors, direction: direction, size: base.bounds.size)
    }
    
    /// 为视图添加线性渐变图层 (自定义渐变图层大小)
    func addGradientLayer(colors: [UIColor?], direction: GradientDirection = .leftToRight, size: CGSize) {
        guard size.pk.isValid else { return }
        
        var gradientLayer: CAGradientLayer!
        if let layer = base.pk_gradientLayer {
            gradientLayer = layer
            gradientLayer.frame = CGRect(origin: .zero, size: size)
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.frame = CGRect(origin: .zero, size: size)
            gradientLayer.colors = colors.map({ $0?.cgColor ?? UIColor.black.cgColor })
            base.layer.insertSublayer(gradientLayer, at: 0)
            base.pk_gradientLayer = gradientLayer
        }
        
        switch direction {
        case .leftToRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .rightToLeft:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .topToBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .bottomToTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        case .leftTopToRightBottom:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .leftBottomToRightTop:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        case .rightTopToLeftBottom:
            gradientLayer.startPoint = CGPoint(x: 1, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        case .rightBottomToLeftTop:
            gradientLayer.startPoint = CGPoint(x: 1, y: 1)
            gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        }
    }
    
    /// 删除渐变图层 (对应-addGradientLayer:方法)
    func removeGradientLayer() {
        base.pk_gradientLayer?.removeFromSuperlayer()
        base.pk_gradientLayer = nil
    }
}

public extension PKViewExtensions where Base: UIView {
    
    /// 提示窗是否显示中
    var isAlerting: Bool {
        return base.pk_alertVisible
    }

    /// 显示提示文本框
    /// - Parameters:
    ///   - text: 提示文本
    ///   - delay: 显示时长
    ///   - offset: 位置偏移
    func showAlert(text: String?, delay: TimeInterval = 1.5, offset: CGFloat = -15) {
        guard !isAlerting else { return }
        guard let message = text else { return }
        
        let hud = UIView()
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        hud.clipsToBounds = true
        hud.layer.cornerRadius = 2
        base.addSubview(hud)
        
        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.preferredMaxLayoutWidth = 220
        hud.addSubview(label)
        
        label.pk.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        hud.pk.makeConstraints { (make) in
            let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
            make.left.equalTo(label).offset(-insets.left)
            make.right.equalTo(label).offset(insets.right)
            make.top.equalTo(label).offset(-insets.top)
            make.bottom.equalTo(label).offset(insets.bottom)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(offset)
        }
        
        hud.alpha = 0
        UIView.animate(withDuration: 0.25) {
            hud.alpha = 1
        }
        
        base.pk_alertVisible = true
        DispatchQueue.pk.asyncAfter(delay: delay) {
            UIView.animate(withDuration: 0.25, animations: {
                hud.alpha = 0
            }) { (_) in
                hud.removeFromSuperview()
                self.base.pk_alertVisible = false
            }
        }
    }
}

public extension PKViewExtensions where Base: UIView {
    
    /// 指示器是否加载中
    var isIndicatorLoading: Bool {
        return (base.pk_loadingViewSet != nil)
    }
    
    /// 开启指示器加载效果
    func beginIndicatorLoading(text: String? = nil, tintColor: UIColor = .gray, offset: CGFloat = 0) {
        guard base.pk_loadingViewSet == nil else { return }
        base.pk_loadingViewSet = Set()
        
        let indicatorView: UIActivityIndicatorView!
        if #available(iOS 13.0, *) {
            indicatorView = UIActivityIndicatorView(style: .medium)
        } else {
            indicatorView = UIActivityIndicatorView(style: .gray)
        }
        indicatorView.hidesWhenStopped = false
        indicatorView.color = tintColor
        indicatorView.startAnimating()
        base.addSubview(indicatorView)
        base.pk_loadingViewSet?.insert(indicatorView)
        
        if let message = text {
            let textLabel = UILabel()
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            textLabel.font = UIFont.systemFont(ofSize: 12)
            textLabel.textColor = tintColor
            textLabel.text = message
            base.addSubview(textLabel)
            base.pk_loadingViewSet?.insert(textLabel)
            
            let gapView = UIView()
            base.addSubview(gapView)
            base.pk_loadingViewSet?.insert(gapView)
            
            gapView.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(offset)
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.height.equalTo(8)
            }
            
            indicatorView.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(gapView.pk.top)
            }
            
            textLabel.pk.makeConstraints { (make) in
                make.left.equalTo(10)
                make.right.equalTo(-10)
                make.top.equalTo(gapView.pk.bottom)
            }
        } else {
            indicatorView.pk.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(offset)
            }
        }
    }
    
    /// 结束指示器加载效果
    func endIndicatorLoading() {
        guard base.pk_loadingViewSet != nil else { return }
        base.pk_loadingViewSet?.forEach({ $0.removeFromSuperview() })
        base.pk_loadingViewSet?.removeAll()
        base.pk_loadingViewSet = nil
    }
}

public extension PKViewExtensions where Base: UIView {
    
    /// 为视图添加轻按手势
    @discardableResult
    func addTapGesture(numberOfTaps: Int = 1, action: @escaping (UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer.pk.addGestureHandler { (g) in
            action(g as! UITapGestureRecognizer)
        }
        tap.numberOfTapsRequired = numberOfTaps
        base.addGestureRecognizer(tap)
        base.isUserInteractionEnabled = true
        return tap
    }
    
    /// 为视图添加双击手势 (参数-other：当响应双击手势时，使other手势不会被响应)
    @discardableResult
    func addDoubleTapGesture(lapsed other: UIGestureRecognizer? = nil, action: @escaping (UITapGestureRecognizer) -> Void) -> UITapGestureRecognizer {
        let doubleTap = UITapGestureRecognizer.pk.addGestureHandler { (g) in
            action(g as! UITapGestureRecognizer)
        }
        doubleTap.numberOfTapsRequired = 2
        if let g = other { g.require(toFail: doubleTap) }
        base.addGestureRecognizer(doubleTap)
        base.isUserInteractionEnabled = true
        return doubleTap
    }
    
    /// 为视图添加长按手势
    @discardableResult
    func addLongPressGesture(action: @escaping (UILongPressGestureRecognizer) -> Void) -> UILongPressGestureRecognizer {
        let longPress = UILongPressGestureRecognizer.pk.addGestureHandler { (g) in
            action(g as! UILongPressGestureRecognizer)
        }
        base.addGestureRecognizer(longPress)
        base.isUserInteractionEnabled = true
        return longPress
    }
    
    /// 为视图添加拖动手势
    @discardableResult
    func addPanGesture(action: @escaping (UIPanGestureRecognizer) -> Void) -> UIPanGestureRecognizer {
        let pan = UIPanGestureRecognizer.pk.addGestureHandler { (g) in
            action(g as! UIPanGestureRecognizer)
        }
        base.addGestureRecognizer(pan)
        base.isUserInteractionEnabled = true
        return pan
    }
    
    /// 为视图添加捏合手势
    @discardableResult
    func addPinchGesture(action: @escaping (UIPinchGestureRecognizer) -> Void) -> UIPinchGestureRecognizer {
        let pinch = UIPinchGestureRecognizer.pk.addGestureHandler { (g) in
            action(g as! UIPinchGestureRecognizer)
        }
        base.addGestureRecognizer(pinch)
        base.isUserInteractionEnabled = true
        return pinch
    }
    
    /// 为视图添加滑动手势
    @discardableResult
    func addSwipeGesture(numberOfTouches: Int = 1, direction: UISwipeGestureRecognizer.Direction, action: @escaping (UISwipeGestureRecognizer) -> Void) -> UISwipeGestureRecognizer {
        let swipe = UISwipeGestureRecognizer.pk.addGestureHandler { (g) in
            action(g as! UISwipeGestureRecognizer)
        }
        swipe.numberOfTouchesRequired = numberOfTouches
        swipe.direction = direction
        base.addGestureRecognizer(swipe)
        base.isUserInteractionEnabled = true
        return swipe
    }
}

private var UIViewAssociatedPKMakeBorderLineKey: Void?
private var UIViewAssociatedPKMakeGradientKey: Void?
private var UIViewAssociatedPKAlertVisibleKey: Void?
private var UIViewAssociatedPKLoadingViewsKey: Void?

private extension UIView {
    var pk_borderLayer: CAShapeLayer? {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKMakeBorderLineKey) as? CAShapeLayer
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKMakeBorderLineKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pk_gradientLayer: CAGradientLayer? {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKMakeGradientKey) as? CAGradientLayer
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKMakeGradientKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pk_alertVisible: Bool {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKAlertVisibleKey) as? Bool ?? false
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKAlertVisibleKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var pk_loadingViewSet: Set<UIView>? {
        get {
            return objc_getAssociatedObject(self, &UIViewAssociatedPKLoadingViewsKey) as? Set
        } set {
            objc_setAssociatedObject(self, &UIViewAssociatedPKLoadingViewsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

public struct PKViewExtensions<Base> {
    var base: Base
    fileprivate init(_ base: Base) { self.base = base }
}

public protocol PKViewExtensionsCompatible {}

public extension PKViewExtensionsCompatible {
    static var pk: PKViewExtensions<Self>.Type { PKViewExtensions<Self>.self }
    var pk: PKViewExtensions<Self> { get{ PKViewExtensions(self) } set{} }
}

extension UIView: PKViewExtensionsCompatible {}

public extension UIView {
    
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
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
}
