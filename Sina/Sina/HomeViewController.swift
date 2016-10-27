//
//  HomeViewController.swift
//  Sina
//
//  Created by Leo on 16/10/23.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import SVProgressHUD
class HomeViewController: BaseViewController{
    /// 保存所有微博数据
    var statuses: [StatusViewModel]?
        {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if !isLogin
        {
            // 设置访客视图
            visitorView?.setupVisitorInfo(nil, title: "关注一些人，回这里看看有什么惊喜")
            return
        }
        // 2.初始化导航条
        setupNav()
        // 3.注册通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.titleChange), name: PresentationManagerDidPresented, object: animatorManager)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.titleChange), name: PresentationManagerDidDismissed, object: animatorManager)
        loadData()

    }
    deinit
    {
        // 移除通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    @objc private func titleChange()
    {
        titleButton.selected = !titleButton.selected
    }

    // MARK: - 内部控制方法
    private func setupNav()
    {
        // 1.添加左右按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "navigationbar_friendattention", target: self, action: #selector(HomeViewController.leftBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(imageName: "navigationbar_pop", target: self, action: #selector(HomeViewController.rightBtnClick))
        
        // 2.添加标题按钮

        navigationItem.titleView = titleButton
    }
    
    @objc private func titleBtnClick(btn: TitleButton)
    {
        btn.selected = !btn.selected
        // 2.显示菜单
        // 2.1创建菜单
        let sb = UIStoryboard(name: "Popover", bundle: nil)
        guard let menuView = sb.instantiateInitialViewController() else
        {
            NJLog("menuView")
            return
        }
        // 自定义专场动画
        // 设置转场代理
        menuView.transitioningDelegate = animatorManager
        // 设置转场动画样式
        menuView.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        // 2.2弹出菜单
        presentViewController(menuView, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - 内部控制方法
    private func loadData()
    {
        NetworkTools.shareInstance.loadStatuses { (array, error) -> () in
            // 1.安全校验
            if error != nil
            {
                SVProgressHUD.setStatus("获取微博数据失败")
                SVProgressHUD.setDefaultStyle(.Dark)
                SVProgressHUD.show()
                return
            }
            guard let arr = array else
            {
                return
            }
            
            // 2.将字典数组转换为模型数组
            var models = [StatusViewModel]()
            for dict in arr
            {
                let status = Status(dict: dict)
                let viewModel = StatusViewModel(status: status)
                models.append(viewModel)
            }
            
            // 3.保存微博数据
            self.statuses = models
        }
    }

    @objc private func leftBtnClick()
    {
        NJLog("")
    }
    @objc private func rightBtnClick()
    {
        // 1.创建二维码控制器
        let sb = UIStoryboard(name: "QRCode", bundle: nil)
        let vc = sb.instantiateInitialViewController()!
        // 2.弹出二维码控制器
        presentViewController(vc, animated: true, completion: nil)
        NJLog("")
    }
    private lazy var animatorManager: PresentationManager = {
        let manager = PresentationManager()
        manager.presentFrame = CGRect(x: 100, y: 45, width: 200, height: 500)
        return manager
    }()
    
    /// 标题按钮
    private lazy var titleButton: TitleButton = {
        let btn = TitleButton()
        let title = UserAccount.loadUserAccount()?.screen_name
        btn.setTitle(title, forState: UIControlState.Normal)
        btn.addTarget(self, action: #selector(HomeViewController.titleBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()

}
extension HomeViewController
{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.statuses?.count ?? 0
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 1.取出cell
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as! HomeTableViewCell
        // 2.设置数据
        cell.viewModel = statuses![indexPath.row]
        // 3.返回cell
        return cell
    }
}

