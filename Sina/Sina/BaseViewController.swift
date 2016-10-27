//
//  BaseViewController.swift
//  Sina
//
//  Created by Leo on 16/10/24.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController,VisitorViewDelegate{

    var isLogin = UserAccount.isLogin()
    /// 访客视图
    var visitorView: VisitorView?
    override func loadView() {
        // 判断用户是否登录, 如果没有登录就显示访客界面, 如果已经登录就显示tableview
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    // MARK: - 内部控制方法
    private func setupVisitorView()
    {
        // 1.创建访客视图
        visitorView = VisitorView.visitorView()
        view = visitorView
        // 2.设置代理
//       visitorView?.delegate = self
        visitorView?.LoginBtn.addTarget(self, action: #selector(BaseViewController.loginBtnClick(_:)),  forControlEvents: UIControlEvents.TouchUpInside)
        visitorView?.registerBtn.addTarget(self, action: #selector(BaseViewController.registerBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 3.添加导航条按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.registerBtnClick(_:)))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(BaseViewController.loginBtnClick(_:)))
    }
    @objc private func loginBtnClick(btn: UIButton)
    {
        // 1.创建登录界面
        let sb = UIStoryboard(name: "OAuth", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        // 2.弹出登录界面
        presentViewController(vc, animated: true, completion: nil)
    }
    @objc private func registerBtnClick(btn: UIButton)
    {
        NJLog("")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func visitorViewDidClickLoginBtn(vistor:VisitorView)
    {
         NJLog("")
    }
    func visitorViewDidClickRegisterBtn(vistor:VisitorView)
    {
         NJLog("")
    }


    
}
