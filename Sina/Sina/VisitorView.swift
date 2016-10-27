//
//  VisitorView.swift
//  Sina
//
//  Created by Leo on 16/10/24.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
protocol VisitorViewDelegate:NSObjectProtocol {
    func visitorViewDidClickLoginBtn(vistor:VisitorView)
    func visitorViewDidClickRegisterBtn(vistor:VisitorView)
//    func visitorViewDidClickLoginBtn(vistor:VisitorView)
}

class VisitorView: UIView {
    
    @IBOutlet weak var LoginBtn: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!

    /// 文本标签
    @IBOutlet weak var titleLabel: UILabel!
        /// 转盘
    @IBOutlet weak var rotationImageView: UIImageView!

    /// 图标
    @IBOutlet weak var iconImageView: UIImageView!
 
    /// 代理
    // 和OC一样代理属性必须使用weak修饰
    weak var delegate: VisitorViewDelegate?
    
    @IBAction func register(sender: AnyObject) {
        
    delegate?.visitorViewDidClickRegisterBtn(self)
    }
    @IBAction func login(sender: AnyObject) {
        
        delegate?.visitorViewDidClickLoginBtn(self)
    }
    /// 设置访客视图上的数据
    /// imageName需要显示的图标
    /// title需要显示的标题
    func setupVisitorInfo(imageName: String? , title: String)
    {
        // 1.设置标题
        titleLabel.text = title
        
        // 2.判断是否是首页
        guard let name = imageName else
        {
            // 没有设置图标, 首页
            // 执行转盘动画
            startAniamtion()
            return
        }
        
        // 3.设置其他数据
        // 不是首页
        rotationImageView.hidden = true
        
        iconImageView.image = UIImage(named: name)
        
    }
    
    /// 转盘旋转动画
    private func startAniamtion()
    {
        // 1.创建动画
        let anim =  CABasicAnimation(keyPath: "transform.rotation")
        
        // 2.设置动画属性
        anim.toValue = 2 * M_PI
        anim.duration = 5.0
        anim.repeatCount = MAXFLOAT
        
        // 注意: 默认情况下只要视图消失, 系统就会自动移除动画
        // 只要设置removedOnCompletion为false, 系统就不会移除动画
        anim.removedOnCompletion = false
        
        // 3.将动画添加到图层上
        rotationImageView.layer.addAnimation(anim, forKey: nil)
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    class func visitorView() ->VisitorView {
        return NSBundle.mainBundle().loadNibNamed("VisitorView", owner: nil, options: nil).last as! VisitorView
    }

}
