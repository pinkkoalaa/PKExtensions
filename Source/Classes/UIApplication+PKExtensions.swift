//
//  UIApplication+PKExtensions.swift
//  PKExtensions
//
//  Created by zhanghao on 2020/2/23.
//  Copyright © 2020 Psychokinesis. All rights reserved.
//

import UIKit

public extension PKApplicationExtensions {
    
    /// 获取应用程序的主窗口
    static var keyWindow: UIWindow? {
        if let window = UIApplication.shared.delegate?.window as? UIWindow {
            return window;
        }
        
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }

    /// 获取当前程序的顶层控制器
    static func topViewController() -> UIViewController? {
        func findTopViewController(_ current: UIViewController?) -> UIViewController? {
            if let presented = current?.presentedViewController {
                return findTopViewController(presented)
            }
            
            if let tabbarController = current as? UITabBarController {
                return findTopViewController(tabbarController.selectedViewController)
            }
            
            if let navigationController = current as? UINavigationController {
                return findTopViewController(navigationController.topViewController)
            }
            return current
        }
        return findTopViewController(keyWindow?.rootViewController)
    }
    
    /// 程序后台挂起时运行该闭包任务
    func runInBackground(_ closure: @escaping () -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = self.base.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = self.base.beginBackgroundTask(expirationHandler: { })
            }
            closure()
            self.base.endBackgroundTask(taskID)
        }
    }
}

public extension PKApplicationExtensions {
    
    enum Environment {
        /// 应用程序在调试模式下运行
        case debug
        /// 应用程序从TestFlight安装
        case testFlight
        /// 应用程序从AppStore安装
        case appStore
    }
    
    /// 获取应用程序运行环境
    func inferredEnvironment() -> Environment {
        #if DEBUG
        return .debug

        #elseif targetEnvironment(simulator)
        return .debug

        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        }

        guard let appStoreReceiptUrl = Bundle.main.appStoreReceiptURL else {
            return .debug
        }

        if appStoreReceiptUrl.lastPathComponent.lowercased() == "sandboxreceipt" {
            return .testFlight
        }

        if appStoreReceiptUrl.path.lowercased().contains("simulator") {
            return .debug
        }

        return .appStore
        #endif
    }
    
    /// 获取应用名称
    var displayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }

    /// 获取应用构建版本号(包括发布与未发布)
    var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }

    /// 获取应用当前版本号(发布版本号)
    var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

public struct PKApplicationExtensions {
    fileprivate static var Base: UIApplication.Type { UIApplication.self }
    fileprivate var base: UIApplication
    fileprivate init(_ base: UIApplication) { self.base = base }
}

public extension UIApplication {
    var pk: PKApplicationExtensions { PKApplicationExtensions(self) }
    static var pk: PKApplicationExtensions.Type { PKApplicationExtensions.self }
}
