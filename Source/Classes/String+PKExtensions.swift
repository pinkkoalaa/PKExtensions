//
//  String+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/24.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKStringExtensions {
    
    /// 检查字符串是否为空或只包含空白和换行字符
    var isBlank: Bool {
        let trimmed = base.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /// 返回字符串中出现指定字符的第一个索引
    func index(of char: Character) -> Int? {
        for (index, c) in base.enumerated() where c == char {
            return index
        }
        return nil
    }
    
    /// 字符串查找子串返回NSRange
    func range(of subString: String?) -> NSRange {
        guard let subValue = subString else { return NSRange(location: 0, length: 0) }
        let swiftRange = base.range(of: subValue)
        return NSRange(swiftRange!, in: base)
    }
    
    /// 计算文本所对应的视图大小
    func size(constraint size: CGSize, font: UIFont? = nil, lineBreakMode: NSLineBreakMode? = .byCharWrapping) -> CGSize {
        var attrib: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)]
        if lineBreakMode != nil {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = lineBreakMode!
            attrib.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        let rect = (base as NSString).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attrib, context: nil)
        return CGSize(width: ceil(rect.width), height: ceil(rect.height))
    }
    
    /// 计算文本宽度 (约束高度)
    func width(constraint height: CGFloat, font: UIFont? = nil, lineBreakMode: NSLineBreakMode? = .byCharWrapping) -> CGFloat {
        let size = CGSize(width: CGFloat(Double.greatestFiniteMagnitude), height: height)
        return self.size(constraint: size, font: font, lineBreakMode: lineBreakMode).width
    }
    
    /// 计算文本高度 (约束宽度)
    func height(constraint width: CGFloat, font: UIFont? = nil, lineBreakMode: NSLineBreakMode? = .byCharWrapping) -> CGFloat {
        let size = CGSize(width: width, height: CGFloat(Double.greatestFiniteMagnitude))
        return self.size(constraint: size, font: font, lineBreakMode: lineBreakMode).height
    }
}

public extension PKStringExtensions {
    
    /// 将String转为Int
    func toInt() -> Int? { Int(base) }
    
    /// 将String转为Double
    func toDouble() -> Double? { Double(base) }
    
    /// 将String转CGFloat
    func toCGFloat() -> CGFloat? {
        guard let doubleValue = Double(base) else { return nil }
        return CGFloat(doubleValue)
    }
    
    /// 将String转NSString
    func toNSString() -> NSString {
        return NSString(string: base)
    }
}

public extension PKStringExtensions {
    
    /// 将数字金额字符串转成人民币朗读形式
    func rmbCapitalized() -> String {
        guard let number = Double(base) else { return "" }
        return number.pk.stringRmbCapitalized()
    }
    
    /// 检查字符串中是否包含Emoji
    func containsEmoji() -> Bool {
        for i in 0..<base.count {
            let c: unichar = (base as NSString).character(at: i)
            if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
                return true
            }
        }
        return false
    }
    
    /// 转为驼峰式字符串
    ///
    ///     "sOme vAriable naMe".pk.camelCased() -> "someVariableName"
    func camelCased() -> String {
        let source = base.lowercased()
        let first = source[..<source.index(after: source.startIndex)]
        if source.contains(" ") {
            let connected = source.capitalized.replacingOccurrences(of: " ", with: "")
            let camel = connected.replacingOccurrences(of: "\n", with: "")
            let rest = String(camel.dropFirst())
            return first + rest
        }
        let rest = String(source.dropFirst())
        return first + rest
    }
    
    /// 返回给定长度的随机字符串
    ///
    ///     String.pk.random(ofLength: 18) -> "u7MMZYvGo9obcOcPj8"
    static func random(ofLength length: Int) -> String {
        guard length > 0 else { return "" }
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            randomString.append(base.randomElement()!)
        }
        return randomString
    }
}

public extension PKStringExtensions {
    
    /// 检查字符串是否是有效的URL
    var isValidURL: Bool {
        return URL(string: base) != nil
    }
    
    /// 检查字符串是否是有效的https URL
    var isValidHttpsURL: Bool {
        guard let url = URL(string: base) else { return false }
        return url.scheme == "https"
    }
    
    /// 检查字符串是否是有效的文件URL
    var isValidFileURL: Bool {
        return URL(string: base)?.isFileURL ?? false
    }
    
    /// 检查字符串是否是有效的邮件格式
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return base.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

public struct PKStringExtensions {
    fileprivate static var Base: String.Type { String.self }
    fileprivate var base: String
    fileprivate init(_ base: String) { self.base = base }
}

public extension String {
    var pk: PKStringExtensions { PKStringExtensions(self) }
    static var pk: PKStringExtensions.Type { PKStringExtensions.self }
}
