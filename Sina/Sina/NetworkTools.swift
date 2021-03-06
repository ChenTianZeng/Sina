//
//  NetworkTools.swift
//  Sina
//
//  Created by Leo on 16/10/25.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkTools: AFHTTPSessionManager {
    
    // Swift推荐我们这样编写单例
    static let shareInstance: NetworkTools = {
        
        // 注意: baseURL后面一定更要写上./
        let baseURL = NSURL(string: "https://api.weibo.com/")!
        
        let instance = NetworkTools(baseURL: baseURL, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
      instance.responseSerializer.acceptableContentTypes = NSSet(objects:"application/json", "text/json", "text/javascript", "text/plain") as? Set
        
        return instance
    }()
    func loadStatuses(finished: (array: [[String: AnyObject]]?, error: NSError?)->())
    {
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能获取微博数据")
        
        // 1.准备路径
        let path = "2/statuses/home_timeline.json"
        // 2.准备参数
        let parameters = ["access_token": UserAccount.loadUserAccount()!.access_token!]
        // 3.发送GET请求
        GET(path, parameters: parameters , progress: nil, success: { (task, objc) in
            guard let arr = (objc as! [String: AnyObject])["statuses"] as? [[String: AnyObject]] else
            {
                finished(array: nil, error: NSError(domain: "com.520it.lnj", code: 1000, userInfo: ["message": "没有获取到数据"]))
                return
            }
            finished(array: arr, error: nil)
            }) { (task, error) in
                 finished(array: nil, error: error)
        }
      }

}
