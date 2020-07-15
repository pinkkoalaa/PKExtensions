//
//  NextViewController.swift
//  PKExtensions
//
//  Created by corgi on 2020/6/23.
//  Copyright © 2020 Pink Koala. All rights reserved.
//

import UIKit

class NextViewController: UIViewController, UITextFieldDelegate {

//    let _Titles = "The 1896 Cedar Keys hurricane was a powerful tropical cyclone that devastated much of the East Coast of the United States, starting with Florida's Cedar Keys, near the end of September. The storm's rapid movement allowed it to maintain much of its intensity after landfall, becoming one of the costliest United States hurricanes at the time. "
   
    let _Titles = "新华社华盛顿7月14日电（记者徐剑梅　邓仙来）美国波士顿联邦地区法院法官伯勒斯14日在开庭审理哈佛大学和麻省理工学院提起的相关诉讼时宣布，美国政府同意撤销此前发布的留学生签证新规。"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        example7()
        example8()
    }
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
//        label.font = UIFont.pk.fontName(.dINCondensed, style: .bold, size: 34)
//        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
        label.backgroundColor = .orange
        
        let attrig = NSMutableAttributedString(string: _Titles)
        attrig.pk.font(UIFont.pk.fontName(.pingFangSC, style: .medium, size: 24))
        attrig.pk.foregroundColor(.white)
        attrig.pk.setUnderlineStyle(.single, range: NSRange(location: 5, length: 20))
        attrig.pk.setUnderlineColor(.red, range: NSRange(location: 5, length: 20))
        attrig.pk.kern(5)
        attrig.pk.setFont(UIFont.pk.fontName(.dINCondensed, style: .bold, size: 34), range: NSRange(location: 25, length: 20))
        
        let style = NSMutableParagraphStyle()
        style.pk.lineSpacing(10)
        style.pk.firstLineHeadIndent(20)
        attrig.pk.paragraphStyle(style)
        
        label.attributedText = attrig
        
        return label
    }
    
    func example7() {
        let label = makeLabel()
        label.backgroundColor = UIColor.pk.random(.gentle)
        view.addSubview(label)

        let maxSize = CGSize(width: view.bounds.width - 20, height: .greatestFiniteMagnitude)
        let _size = label.attributedText!.pk.boundingSize(with: maxSize)
        label.size = _size
        label.left = 10
        label.top = 100
    }
    
    func example8() {
        let label = makeLabel()
        label.backgroundColor = UIColor.pk.random(.gentle)
        view.addSubview(label)
        
        let maxSize = CGSize(width: view.bounds.width - 20, height: .greatestFiniteMagnitude)
        let _size = label.sizeThatFits(maxSize)
//        label.sizeToFit()
        label.size = _size
        label.left = 10
        label.bottom = view.height - 20
    }
    
    

    func example6() {
        let textField = IngenuityTextField()
        textField.delegate = self
        textField.backgroundColor = .lightGray
        textField.pk.setPlaceHolder("请输入文字")
        textField.tintColor = .red
        view.addSubview(textField)
        
        let imgView = UIImageView()
        imgView.image = UIImage(named: "sheet_Collection")
        imgView.size = CGSize(width: 20, height: 20)
        
        let backView = UIView()
        backView.size = CGSize(width: 20, height: 20)
        backView.addSubview(imgView)

        textField.leftView = backView
        textField.leftViewMode = .whileEditing
        textField.leftViewPadding = 20
        textField.textEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        let riImgView = UIImageView()
        riImgView.image = UIImage(named: "sheet_Collection")
        riImgView.size = CGSize(width: 20, height: 20)

        let rightBackView = UIView()
        rightBackView.size = CGSize(width: 20, height: 20)
        rightBackView.addSubview(riImgView)
        
        textField.clearButtonPadding = 10
        textField.clearButtonMode = .whileEditing;
        
        textField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(70)
            make.top.equalTo(200)
        }
        
        view.pk.addTapGesture { _ in
            textField.resignFirstResponder()
        }
        
        textField.addTarget(self, action: #selector(textFieldDeleteBackward(_:)), for: IngenuityTextField.deleteBackward)
    }
    
    @objc func textFieldDeleteBackward(_ textField: UITextField) {
        print("textFieldDeleteBackward-textFieldDeleteBackward")
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
            UIAlertController.pk.show(message: "clicked！")
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
