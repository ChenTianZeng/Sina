//
//  UIBarButtonItem+Extension.swift
//  Sina
//
//  Created by Leo on 16/10/24.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
extension UIBarButtonItem
{
    convenience init(imageName: String, target: AnyObject?, action: Selector)
    {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        btn.setImage(UIImage(named: imageName+"_highlighted"), forState: UIControlState.Selected)
      
        btn.sizeToFit()
        btn.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        self.init(customView: btn)
    }

}
