//
//  Date+Extion.swift
//  Sina
//
//  Created by Leo on 16/10/27.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit

extension NSDate
{
    /// 根据一个字符串创建一个NSDate
    class func createDate(timeStr: String, formatterStr: String) -> NSDate
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = formatterStr
        // 如果不指定以下代码, 在真机中可能无法转换
        formatter.locale = NSLocale(localeIdentifier: "en")
        return formatter.dateFromString(timeStr)!
    }
    
    /// 生成当前时间对应的字符串
    func descriptionStr() -> String
    {
        // 1.创建时间格式化对象
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        // 2.创建一个日历类
        let calendar = NSCalendar.currentCalendar()
        
        // 3.定义变量记录时间格式
        var formatterStr = "HH:mm"
        
        // 4.判断是否是今天
        if calendar.isDateInToday(self)
        {
            // 今天
            // 3.比较两个时间之间的差值
            let interval = Int(NSDate().timeIntervalSinceDate(self))
            
            if interval < 60
            {
                return "刚刚"
            }else if interval < 60 * 60
            {
                return "\(interval / 60)分钟前"
            }else if interval < 60 * 60 * 24
            {
                return "\(interval / (60 * 60))小时前"
            }
        }else if calendar.isDateInYesterday(self)
        {
            // 昨天
            formatterStr = "昨天 " + formatterStr
        }else
        {
            // 该方法可以获取两个时间之间的差值
            let comps  = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            if comps.year >= 1
            {
                // 更早时间
                formatterStr = "yyyy-MM-dd " + formatterStr
            }else
            {
                // 一年以内
                formatterStr = "MM-dd " + formatterStr
            }
        }
        formatter.dateFormat = formatterStr
        return formatter.stringFromDate(self)
    }
}
