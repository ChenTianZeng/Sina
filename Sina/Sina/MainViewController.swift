//
//  MainViewController.swift
//  Sina
//
//  Created by Leo on 16/10/23.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        tabBar.tintColor = UIColor.orangeColor()
//        addChildViewControllers()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        tabBar.addSubview(composeButton)
        // 保存按钮尺寸
        let rect = composeButton.frame
        // 计算宽度
        let width = tabBar.bounds.width / CGFloat(childViewControllers.count)
        // 设置按钮的位置
        composeButton.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    func addChildViewControllers() {
        guard let filePath =  NSBundle.mainBundle().pathForResource("MainVCSettings.json", ofType: nil) else
        {
            NJLog("JSON文件不存在")
            return
        }
        
        guard let data = NSData(contentsOfFile: filePath) else
        {
            NJLog("加载二进制数据失败")
            return
        }
      
        do
        {
            
            let objc = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! [[String: AnyObject]]
            // 1.3遍历数组字典取出每一个字典
            for dict in objc
            {
                // 1.4根据遍历到的字典创建控制器
                let title = dict["title"] as? String
                let vcName = dict["vcName"] as? String
                let imageName = dict["imageName"] as? String
                addChildViewController(vcName!, title: title!,  imageName: imageName!)
            }
        }catch
        {
            // 只要try对应的方法发生了异常, 就会执行catch{}中的代码
            addChildViewController("HomeViewController", title: "首页", imageName: "tabbar_home")
            addChildViewController("MessageViewController", title: "消息", imageName: "tabbar_message_center")
            addChildViewController("NullViewController", title:"" , imageName:"" )
            addChildViewController("DiscoverViewController", title: "发现", imageName: "tabbar_discover")
            addChildViewController("ProfileViewController", title: "我", imageName: "tabbar_profile")
        }
    }
    
      func addChildViewController(childControllerName: String, title: String, imageName: String) {
        
        guard let name =  NSBundle.mainBundle().infoDictionary!["CFBundleExecutable"] as? String else
        {
            NJLog("获取命名空间失败")
            return
        }
        
        let cls: AnyClass? = NSClassFromString(name + "." + childControllerName)
        guard  let typeCls = cls as? UITableViewController.Type
        else
        {
            NJLog("cls不能当做UITableViewController")
            return
        }
 
        let childController = typeCls.init()
        NJLog(childController)
    
         childController.title = title
         childController.tabBarItem.image = UIImage(named: imageName)
         childController.tabBarItem.selectedImage = UIImage(named: imageName + "_highlighted")
         
         
         // 1.3包装一个导航控制器
         let nav = UINavigationController(rootViewController: childController)
         // 1.4将子控制器添加到UITabBarController中
         addChildViewController(nav)
    
    }

    @objc private func compseBtnClick(btn: UIButton)
    {
        NJLog(btn)
    }
    // MARK: - 懒加载
    private lazy var composeButton: UIButton = {
        () -> UIButton
        in
        // 1.创建按钮
        let btn = UIButton(imageName:"tabbar_compose_icon_add", backgroundImageName: "tabbar_compose_button")
        
        // 2.监听按钮点击
        btn.addTarget(self, action: #selector(MainViewController.compseBtnClick(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()

}
