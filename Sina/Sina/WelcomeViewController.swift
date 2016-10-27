//
//  WelcomeViewController.swift
//  Sina
//
//  Created by Leo on 16/10/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import SDWebImage
class WelcomeViewController: UIViewController {

    @IBOutlet weak var IconImage: UIImageView!
    
    @IBOutlet weak var ButtomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLable: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.设置头像圆角
        IconImage.layer.cornerRadius = 45
        //        iconImageView.layer.masksToBounds = true
        IconImage.clipsToBounds = true
        
        assert(UserAccount.loadUserAccount() != nil, "必须授权之后才能显示欢迎界面")
        NJLog(UserAccount.loadUserAccount()!.avatar_large!)
        // 2.设置头像
        guard let url = NSURL(string: UserAccount.loadUserAccount()!.avatar_large!) else
        {
            return
        }
        IconImage.sd_setImageWithURL(url)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // 1.让头像执行动画
        ButtomConstraint.constant = (UIScreen.mainScreen().bounds.height - ButtomConstraint.constant)
        
        UIView.animateWithDuration(2.0, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (_) -> Void in
            
            UIView.animateWithDuration(2.0, animations: { () -> Void in
                self.titleLable.alpha = 1.0
                }, completion: { (_) -> Void in
            
                NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewController, object: true)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
