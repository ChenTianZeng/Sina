//
//  XMGPresentationController.swift
//  Sina
//
//  Created by Leo on 16/10/24.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

class XMGPresentationController: UIPresentationController {
    var presentFrame = CGRectZero
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
    }
    
    // 用于布局转场动画弹出的控件
    override func containerViewWillLayoutSubviews()
    {
        // 设置弹出视图的尺寸
        presentedView()?.frame = presentFrame 
        // 添加蒙版
        containerView?.insertSubview(coverButton, atIndex: 0)
        coverButton.addTarget(self, action: #selector(XMGPresentationController.coverBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    @objc private func coverBtnClick()
    {
        //        NJLog(presentedViewController)
        //        NJLog(presentingViewController)
        // 让菜单消失
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - 懒加载
    private lazy var coverButton: UIButton = {
        let btn = UIButton()
        btn.frame = UIScreen.mainScreen().bounds
        btn.backgroundColor = UIColor.clearColor()
        return btn
    }()


}
