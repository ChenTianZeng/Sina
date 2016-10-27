//
//  NewfeatureViewController.swift
//  Sina
//
//  Created by Leo on 16/10/26.
//  Copyright © 2016年 Leo. All rights reserved.
//

import UIKit
import SnapKit
class NewfeatureViewController: UIViewController {
    private var maxCount = 4
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension NewfeatureViewController: UICollectionViewDataSource
{
    
    // 1.告诉系统有多少组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    // 2.告诉系统每组多少行
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maxCount
    }
    // 3.告诉系统每行显示什么内容
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.获取cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("newfeatureCell", forIndexPath: indexPath) as! NewfeatureCell
        cell.backgroundColor = (indexPath.item % 2 == 0) ? UIColor.redColor() : UIColor.purpleColor()
        // 2.设置数据
        cell.index = indexPath.item
        
        // 3.返回cell
        return cell
    }
}
extension NewfeatureViewController: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        // 注意: 传入的cell和indexPath都是上一页的, 而不是当前页
        //        NJLog(indexPath.item)
        let index = collectionView.indexPathsForVisibleItems().last!
        NJLog(index.item)
        // 2.根据指定的indexPath获取当前显示的cell
        let currentCell = collectionView.cellForItemAtIndexPath(index) as! NewfeatureCell
        // 3.判断当前是否是最后一页
        if index.item == (maxCount - 1)
        {
            // 做动画
            currentCell.startAniamtion()
        }
    }
}
class NewfeatureLayout: UICollectionViewFlowLayout
{
    // 准备布局
    override func prepareLayout() {
        // 1.设置每个cell的尺寸
        itemSize = UIScreen.mainScreen().bounds.size
        // 2.设置cell之间的间隙
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        // 3.设置滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 4.设置分页
        collectionView?.pagingEnabled = true
        // 5.禁用回弹
        collectionView?.bounces = false
        // 6.取出滚动条
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
    }
}
class NewfeatureCell: UICollectionViewCell
{
    var index: Int = 0
        {
        didSet{
            // 1.生成图片名称
            let name = "new_feature_\(index + 1)"
           
            // 2.设置图片
            iconView.image = UIImage(named: name)
            startButton.hidden = true
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - 外部控制方法
    func startAniamtion()
    {
        startButton.hidden = false
        startButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        startButton.userInteractionEnabled = false
        UIView.animateWithDuration(2.0, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            self.startButton.transform = CGAffineTransformIdentity
            }, completion: { (_) -> Void in
                self.startButton.userInteractionEnabled = true
        })
    }
    
    // MARK: - 内部控制方法
    private func setupUI()
    {
        // 1.添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(startButton)
        
        // 2.布局子控件
       iconView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(0)
        }
        startButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-160)
        }
    }
    
    @objc private func startBtnClick()
    {
        NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewController, object: true)
    }
    
    /// 图片容器
    private lazy var iconView = UIImageView()
    /// 开始按钮
    private lazy var startButton: UIButton = {
        let btn = UIButton(imageName:"", backgroundImageName: "new_feature_button")
        btn.addTarget(self, action: #selector(NewfeatureCell.startBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        return btn
    }()
}

