//
//  UIButtonExtion.swift
//  Sina
//
//  Created by Leo on 16/10/24.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
extension UIButton
{
    convenience init(imageName: String, backgroundImageName: String)
    {
        
        self.init()
        // 2.设置前景图片
        if imageName != ""
        {
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Selected)
        }
        // 3.设置背景图片
        if backgroundImageName != ""
        {
        setBackgroundImage(UIImage(named: backgroundImageName), forState: UIControlState.Normal)
        setBackgroundImage(UIImage(named: backgroundImageName+"_highlighted"), forState: UIControlState.Selected)
        }
        // 4.调整按钮尺寸
        sizeToFit()
    }

}
