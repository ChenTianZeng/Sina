
//
//  AppDelegate.swift
//  Sina
//
//  Created by Leo on 16/10/23.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().tintColor=UIColor.orangeColor()
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        // 2.注册监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.changeRootViewController(_:)), name: SwitchRootViewController, object: nil)

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = defaultViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
extension AppDelegate
{
/// 切换根控制器
func changeRootViewController(notice: NSNotification)
{
    if notice.object as! Bool
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        window?.rootViewController = sb.instantiateInitialViewController()!
    }else
    {
        let sb = UIStoryboard(name: "welcome", bundle: nil)
        window?.rootViewController = sb.instantiateInitialViewController()!
    }
}

/// 用于返回默认界面
private func defaultViewController() -> UIViewController
{
    // 1.判断是否登录
    if UserAccount.isLogin()
    {
        // 2.判断是否有新版本
        if isNewVersion()
        {
            let sb = UIStoryboard(name: "Newfeature", bundle: nil)
            return sb.instantiateInitialViewController()!
        }else
        {
            let sb = UIStoryboard(name: "welcome", bundle: nil)
            return sb.instantiateInitialViewController()!
        }
    }
    
    // 没有登录
    let sb = UIStoryboard(name: "Main", bundle: nil)
    return sb.instantiateInitialViewController()!
}

/// 判断是否有新版本
private func isNewVersion() -> Bool
{
    // 1.加载info.plist
    // 2.获取当前软件的版本号
    let currentVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    // 3.获取以前的软件版本号?
    let defaults = NSUserDefaults.standardUserDefaults()
    let sanboxVersion = (defaults.objectForKey("xxoo") as? String) ?? "0.0"
    // 4.用当前的版本号和以前的版本号进行比较
    // 1.0  0.0
    if currentVersion.compare(sanboxVersion) == NSComparisonResult.OrderedDescending
    {
        // 如果当前的大于以前的, 有新版本
        NJLog("有新版本")
        // 如果有新版本, 就利用新版本的版本号更新本地的版本号
        defaults.setObject(currentVersion, forKey: "xxoo")
        defaults.synchronize() // iOS7以前需要写, iOS7以后不用写
        return true
    }
    NJLog("没有新版本")
    return false
}
}
func NJLog<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line)
{
 
    
    #if DEBUG
        print("\(methodName)[\(lineNumber)]:\(message)")
    #endif
   
}
