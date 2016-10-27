//
//  User.swift
//  Sina
//
//  Created by Leo on 16/10/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
class User: NSObject {
    /// 字符串型的用户UID
    var idstr: String?
    /// 用户昵称
    var screen_name: String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url: String?
    /// 用户认证类型
    var verified_type: Int = -1
    /// 会员等级 ,取值范围 1~6
    var mbrank: Int = -1
    init(dict: [String: AnyObject])
    {
        super.init()
        setValuesForKeysWithDictionary(dict)
    }
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        let property = ["idstr", "screen_name", "profile_image_url", "verified_type","mbrank"]
        let dict = dictionaryWithValuesForKeys(property)
        return "\(dict)"
    }
}
