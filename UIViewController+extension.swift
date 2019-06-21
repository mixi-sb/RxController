//
//  UIViewController+extension.swift
//  RxController
//
//  Created by Shoichi Kuraoka on 2019/06/21.
//  Copyright (c) 2019 MuShare. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

extension UIViewController {
    
    var rootRxViewModel: RxViewModel? {
        if let rxVC = self as? RxViewControllerProtocol {
            return rxVC.rxViewModel
        } else if let tabVC = self as? UITabBarController {
            return tabVC.viewControllers?.compactMap { $0.rootRxViewModel }.first
        } else if let naviVC = self as? UINavigationController {
            return naviVC.viewControllers.first?.rootRxViewModel
        } else {
            return nil
        }
    }
    
    var topMostViewController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController
        } else if let navigated = (self as? UINavigationController)?.visibleViewController {
            return navigated.topMostViewController
        } else if let selected = (self as? UITabBarController)?.selectedViewController {
            return selected.topMostViewController
        } else {
            return self
        }
    }
    
}
