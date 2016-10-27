//
//  UserAccount.swift
//  Sina
//
//  Created by Leo on 16/10/25.
//  Copyright © 2016年 Leo. All rights reserved.
//

import Foundation
class UserAccount: NSObject, NSCoding {
    
    var access_token: String?
    var expires_in: Int = 0
        {
        didSet{
            expires_Date=NSDate(timeIntervalSinceNow: NSTimeInterval(expires_in))
        }
    }
    var uid: String?
    var expires_Date:NSDate?
    ///  用户头像地址（大图），180×180像素
    var avatar_large: String?
    
    /// 用户昵称
    var screen_name: String?
    // MARK: - 生命周期方法
    init(dict: [String: AnyObject])
    {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
        // NJLog(self)
    }
    
    // 当KVC发现没有对应的key时就会调用
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    override var description: String {
        // 将模型转换为字典
        let property = ["access_token", "expires_in", "uid","expires_Date"]
        let dict = dictionaryWithValuesForKeys(property)
        // 将字典转换为字符串
        return "\(dict)"
    }
    
    // MARK: - 外部控制方法
    // 归档模型
    func saveAccount() -> Bool
    {    // NJLog(UserAccount.filePath)
        return NSKeyedArchiver.archiveRootObject(self, toFile: UserAccount.filePath)
    }
    
    /// 定义属性保存授权模型
    static var account: UserAccount?
    
    static let filePath: String = "useraccount.plist".cachesDir()
    
    // 解归档模型
    class func loadUserAccount() -> UserAccount?
    { //  NJLog(UserAccount.filePath)
        // 1.判断是否已经加载过了
        if UserAccount.account != nil{
//            NJLog("已经有加载过")
            // 直接返回
            return UserAccount.account
        }
//        NJLog(UserAccount.filePath)
        // 2.尝试从文件中加载
        NJLog("还没有加载过")
        // 3.解归档对象
        guard let account = NSKeyedUnarchiver.unarchiveObjectWithFile(UserAccount.filePath) as? UserAccount else
        {
            return nil
        }
        guard let date = account.expires_Date where date.compare(NSDate()) != NSComparisonResult.OrderedAscending  else
        {
            NJLog("过期了")
            return nil
        }

        UserAccount.account = account
        
        return UserAccount.account
    }
    /// 获取用户信息
    func loadUserInfo(finished: (account: UserAccount?, error: NSError?)->())
    {
        // 断定access_token一定是不等于nil的, 如果运行的时access_token等于nil, 那么程序就会崩溃, 并且报错
        assert(self.access_token != nil, "使用该方法必须先授权")
        NJLog(self.access_token)
        // 1.准备请求路径
        let path = "2/users/show.json"
        // 2.准备请求参数
        let parameters = ["access_token": access_token!, "uid": uid!]
        // 3.发送GET请求
        NetworkTools.shareInstance.GET(path, parameters: parameters, progress: nil, success: { (task, objc) in
            let dict = objc as! [String: AnyObject]
//            NJLog(dict)
            // 1.取出用户信息
            self.avatar_large = dict["avatar_large"] as? String
            self.screen_name = dict["screen_name"] as? String
            
            // 2.保存授权信息
            finished(account: self, error: nil)
            }) { (task, error) in
                NJLog(error)
        }
    }

    /// 判断用户是否登录
    class func isLogin() -> Bool {
        return UserAccount.loadUserAccount() != nil
    }
    
    // MARK: - NSCoding
    func encodeWithCoder(aCoder: NSCoder)
    {
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeInteger(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(expires_Date, forKey: "expires_Date")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        aCoder.encodeObject(screen_name, forKey: "screen_name")
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        self.access_token = aDecoder.decodeObjectForKey("access_token") as? String
        self.expires_in = aDecoder.decodeIntegerForKey("expires_in") as Int
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.expires_Date = aDecoder.decodeObjectForKey("expires_Date") as? NSDate
        self.avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
        self.screen_name = aDecoder.decodeObjectForKey("screen_name") as? String
    }
}

