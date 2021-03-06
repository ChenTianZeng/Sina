//
//  QRCodeViewController.swift
//  XMGWB
//
//  Created by xiaomage on 15/12/2.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

import UIKit
import AVFoundation
class QRCodeViewController: UIViewController {
    /// 底部工具条
    @IBOutlet weak var customTabbar: UITabBar!
    /// 冲击波视图
    @IBOutlet weak var scanLineView: UIImageView!
    /// 容器视图高度约束
    @IBOutlet weak var containerHeightCons: NSLayoutConstraint!
    /// 冲击波顶部约束
    @IBOutlet weak var scanLineCons: NSLayoutConstraint!
    
    @IBOutlet weak var contianer: UIView!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.设置默认选中
        customTabbar.selectedItem = customTabbar.items?.first
        // 2.添加监听, 监听底部工具条点击
        customTabbar.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startAnimation()
    }
    private func scanQRCode()
    {
        // 1.判断输入能否添加到会话中
        if !session.canAddInput(input)
        {
            return
        }
        // 2.判断输出能够添加到会话中
        if !session.canAddOutput(output)
        {
            return
        }
        // 3.添加输入和输出到会话中
        session.addInput(input)
        session.addOutput(output)
        
        // 4.设置输出能够解析的数据类型
        // 注意点: 设置数据类型一定要在输出对象添加到会话之后才能设置
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        
        // 5.设置监听监听输出解析到的数据
        output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        
        // 6.添加预览图层
        view.layer.insertSublayer(previewLayer, atIndex: 0)
        previewLayer.frame = view.bounds
        // 7.添加容器图层
        view.layer.addSublayer(containerLayer)
        containerLayer.frame = view.bounds
        // 8.开始扫描
        session.startRunning()
        
    }

    /// 开启冲击波动画
    private func startAnimation()
    {
        // 1.设置冲击波底部和容器视图顶部对齐
        scanLineCons.constant = -containerHeightCons.constant
        view.layoutIfNeeded()
        // 2.执行扫描动画
        UIView.animateWithDuration(2.0) { () -> Void in
            UIView.setAnimationRepeatCount(MAXFLOAT)
            self.scanLineCons.constant = self.containerHeightCons.constant
            self.view.layoutIfNeeded()
        }

    }
    
    @IBAction func photoBtnClick(sender: AnyObject) {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        {
            return
        }
        // 2.创建相册控制器
        let imagePickerVC = UIImagePickerController()
        
        imagePickerVC.delegate = self
        // 3.弹出相册控制器
        presentViewController(imagePickerVC, animated: true, completion: nil)
        
    }
    @IBAction func closeBtnClick(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    private lazy var input: AVCaptureDeviceInput? = {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        return try? AVCaptureDeviceInput(device: device)
    }()
    
    /// 会话
    private lazy var session: AVCaptureSession = AVCaptureSession()
    
    private lazy var output: AVCaptureMetadataOutput = {
        let out = AVCaptureMetadataOutput()
        // 1.获取屏幕的frame
        let viewRect = self.view.frame
        // 2.获取扫描容器的frame
        let containerRect = self.contianer.frame
        let x = containerRect.origin.y / viewRect.height;
        let y = containerRect.origin.x / viewRect.width;
        let width = containerRect.height / viewRect.height;
        let height = containerRect.width / viewRect.width;
        
        out.rectOfInterest = CGRect(x: x, y: y, width: width, height: height)
        return out
    }()

    /// 预览图层
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.session)
    /// 专门用于保存描边的图层
    private lazy var containerLayer: CALayer = CALayer()

}

extension QRCodeViewController: AVCaptureMetadataOutputObjectsDelegate
{
    
    /// 只要扫描到结果就会调用
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!)
    {
        // 1.显示结果
        textLabel.text =  metadataObjects.last?.stringValue
        
        clearLayers()

        // 2.拿到扫描到的数据
        guard let metadata = metadataObjects.last as? AVMetadataObject else
        {
            return
        }
        // 通过预览图层将corners值转换为我们能识别的类型
        let objc = previewLayer.transformedMetadataObjectForMetadataObject(metadata)
        // 2.对扫描到的二维码进行描边
        drawLines(objc as! AVMetadataMachineReadableCodeObject)
    }

    private func drawLines(objc: AVMetadataMachineReadableCodeObject)
    {
    
        // 0.安全校验
        guard let array = objc.corners else
        {
            return
        }
        
        // 1.创建图层, 用于保存绘制的矩形
        let layer = CAShapeLayer()
        layer.lineWidth = 2
        layer.strokeColor = UIColor.greenColor().CGColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        // 2.创建UIBezierPath, 绘制矩形
        let path = UIBezierPath()
        var point = CGPointZero
        var index = 0
        CGPointMakeWithDictionaryRepresentation((array[index] as! CFDictionary), &point)
        index+=1
        
        // 2.1将起点移动到某一个点
        path.moveToPoint(point)
        
        // 2.2连接其它线段
        while index < array.count
        {
            CGPointMakeWithDictionaryRepresentation((array[index] as! CFDictionary), &point)
            index+=1
            path.addLineToPoint(point)
        }
        // 2.3关闭路径
        path.closePath()
        
        layer.path = path.CGPath
        // 3.将用于保存矩形的图层添加到界面上
        containerLayer.addSublayer(layer)
    }
    
    /// 清空描边
    private func clearLayers()
    {
        guard let subLayers = containerLayer.sublayers else
        {
            return
        }
        for layer in subLayers
        {
            layer.removeFromSuperlayer()
        }
    }
}
extension QRCodeViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
  
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        //        NJLog(info)
      
        // 1.取出选中的图片
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else
        {
            return
        }
        guard let ciImage = CIImage(image: image) else
        {
            return
        }
   
        // 2.从选中的图片中读取二维码数据
        // 2.1创建一个探测器
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        // 2.2利用探测器探测数据
       
        let results = detector.featuresInImage(ciImage)
        // 2.3取出探测到的数据
        for result in results
        {
            NJLog((result as! CIQRCodeFeature).messageString)
        }
        // 注意: 如果实现了该方法, 当选中一张图片时系统就不会自动关闭相册控制器
       picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension QRCodeViewController: UITabBarDelegate
{
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//        NJLog(item.tag)
        // 根据当前选中的按钮重新设置二维码容器高度
        containerHeightCons.constant = (item.tag == 1) ? 150 : 300
        view.layoutIfNeeded()
        // 移除动画
        scanLineView.layer.removeAllAnimations()
        // 重新开启动画
        startAnimation()
    }
}
