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

        let sd = CGFloat(23.3)
        
        let res = sd.pk.flatted()
        print("sd is: \(sd), res is: \(res)")
        
//        example2()
//        example3()
        example5()
    }
    
    func example5() {
        let button = IngenuityButton(type: .custom)
        button.isUserInteractionEnabled = true
        button.backgroundColor = UIColor.lightGray
        button.imagePosition = .left
        button.imageSpecifiedSize = CGSize(width: 12, height: 10)
        button.imageAndTitleSpacing = 15
        view.addSubview(button)
        
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    
        let image = UIImage(named: "fill_arrow_icon")
        button.setImage(image, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("产业筛选", for: .normal)
        
        button.pk.addAction(for: .touchUpInside) { (sender) in
            UIView.animate(withDuration: 0.5, animations: {
                sender.imageView?.transform = CGAffineTransform(rotationAngle: .pi)
            }, completion: nil)
        }
    }
    
    func example3() {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.pk.name(.pingFangSC, style: .medium, size: 17)
        label.textColor = UIColor.orange
        label.backgroundColor = .gray
        label.text = "天九共享平台集团"
        let frame = CGRect(x: 150, y: 150, width: 200, height: 50)
        label.frame = frame
        view.addSubview(label)
        let img = UIImage.pk.gradientImage(with: [.orange, .red], size: CGSize(width: 200, height: 50))
        label.textColor = UIColor(patternImage: img!)
    }
    
    func example2() {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.pk.name(.pingFangSC, style: .medium, size: 17)
        label.textColor = UIColor.orange
//        label.backgroundColor = .gray // mask工作原理：按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
// 设置渐变层的裁剪层
        label.text = "天九共享平台集团"
        view.addSubview(label)

        let colors = [UIColor.orange, UIColor.red]
        let frame = CGRect(x: 150, y: 150, width: 200, height: 50)
        label.frame = frame
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.frame = label.frame
        gradientLayer1.colors = colors.map{( $0.cgColor )}
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 0)
        view.layer.addSublayer(gradientLayer1)
        
        gradientLayer1.mask = label.layer
        label.frame = gradientLayer1.bounds
    }
    
    func example1() {
        var useImage = UIImage(named: "jiazaizhong的副本")
        
        useImage = useImage?.withRenderingMode(.alwaysTemplate)
        
        let imgView = UIImageView()
        imgView.tintColor = .red
        imgView.image = useImage
        imgView.backgroundColor = .white
        imgView.frame = CGRect.init(x: 100, y: 200, width: 40, height: 40)
        view.addSubview(imgView)
        
        view.pk.showToast(message: "正在加载", image: UIImage(named: "jiazaizhong的副本"), isSpin: true, layout: .top, position: .center(offset: 0))
        DispatchQueue.pk.asyncAfter(delay: 2.5) {
            self.view.pk.hideToast()
            self.view.pk.showToast(message: "加载成功", image: UIImage(named: "chenggong-3"), layout: .top, position: .center(offset: 0))
        }
    }
}
