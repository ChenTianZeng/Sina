//
//  StatusViewModel.swift
//  Sina
//
//  Created by Leo on 16/10/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
/*
M: 模型(保存数据)
V: 视图(展现数据)
C: 控制器(管理模型和视图, 桥梁)
VM:
作用: 1.可以对M和V进行瘦身
      2.处理业务逻辑
*/
class StatusViewModel: NSObject {
    /// 模型对象
    var status: Status
    
    init(status: Status)
    {
        self.status = status
        // 处理头像
        icon_URL = NSURL(string: status.user?.profile_image_url ?? "")
        // 处理会员图标
        if status.user?.mbrank >= 1 && status.user?.mbrank <= 6
        {
            mbrankImage = UIImage(named: "common_icon_membership_level\(status.user!.mbrank)")
        }
        // 处理认证图片
        switch status.user?.verified_type ?? -1
        {
        case 0:
            verified_image = UIImage(named: "avatar_vip")
        case 2, 3, 5:
            verified_image = UIImage(named: "avatar_enterprise_vip")
        case 220:
            verified_image = UIImage(named: "avatar_grassroot")
        default:
            verified_image = nil
        }
        
        // 处理来源
        if let sourceStr: NSString = status.source where sourceStr != ""
        {
            // 6.1获取从什么地方开始截取
            let startIndex = sourceStr.rangeOfString(">").location + 1
            // 6.2获取截取多长的长度
            let length = sourceStr.rangeOfString("<", options: NSStringCompareOptions.BackwardsSearch).location - startIndex
            // 6.3截取字符串
            let rest = sourceStr.substringWithRange(NSMakeRange(startIndex, length))
            source_Text = "来自: " + rest
        }
        
        // 处理时间
        // "Sun Dec 06 11:10:41 +0800 2015"
        if let timeStr = status.created_at where timeStr != ""
        {
            // 1.将服务器返回的时间格式化为NSDate
            let createDate = NSDate.createDate(timeStr, formatterStr: "EE MM dd HH:mm:ss Z yyyy")
            
            // 2.生成发布微博时间对应的字符串
            created_Time = createDate.descriptionStr()
        }

    }
    
    /// 用户认证图片
    var verified_image: UIImage?
    
    /// 会员图片
    var mbrankImage: UIImage?

    /// 用户头像URL地址
    var icon_URL: NSURL?
    
    /// 微博格式化之后的创建时间
    var created_Time: String = ""
    
    /// 微博格式化之后的来源
    var source_Text: String = ""
}
