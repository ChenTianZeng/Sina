


//
//  OAuthViewController.swift
//  XMGWB
//
//  Created by Leo on 16/10/25.
//  Copyright © 2016年 xiaomage. All rights reserved.
//

import UIKit
import SVProgressHUD
class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1.定义字符串保存登录界面URL
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
        // 2.创建URL
        guard let url = NSURL(string: urlStr) else
        {
            return
        }
        // 3.创建Request
        let request = NSURLRequest(URL: url)
        
        // 4.加载登录界面
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func close(sender: AnyObject) {
         dismissViewControllerAnimated(true, completion: nil)
    }
  
    @IBAction func write(sender: AnyObject) {
        let jsStr = "document.getElementById('userId').value = '1129288242@qq.com';"
         webView.stringByEvaluatingJavaScriptFromString(jsStr)
    }
}
extension OAuthViewController: UIWebViewDelegate
{
    
    func webViewDidStartLoad(webView: UIWebView) {
        // 显示提醒
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Dark)
        SVProgressHUD.setStatus("正在加载中...")
        SVProgressHUD.show()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        // 关闭提醒
        SVProgressHUD.dismiss()
    }

    // 该方法每次请求都会调用
    // 如果返回false代表不允许请求, 如果返回true代表允许请求
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
              // 1.判断当前是否是授权回调页面
        guard let urlStr = request.URL?.absoluteString else
        {
            return false
        }
        if !urlStr.hasPrefix(WB_Redirect_uri)
        {
            NJLog("不是授权回调页面")
            return true
        }
        
        NJLog("是授权回调页面")
        // 2.判断授权回调地址中是否包含code=
        let key = "code="
        guard let str = request.URL!.query else
        {
            return false
        }
        
        if str.hasPrefix(key)
        {
            let code = str.substringFromIndex(key.endIndex)
             NJLog(code)
            loadAccessToken(code)
            return false
        }
        NJLog("授权失败")
        return false
    }
    
    /// 利用RequestToken换取AccessToken
    private func loadAccessToken(codeStr: String?)
    {
        guard let code = codeStr else
        {
            return
        }
        // 注意:redirect_uri必须和开发中平台中填写的一模一样
        // 1.准备请求路径
        let path = "oauth2/access_token"
        // 2.准备请求参数
//        NJLog(path)
        let parameters = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": code, "redirect_uri": WB_Redirect_uri]
        // 3.发送POST请求
    NetworkTools.shareInstance.POST(path, parameters: parameters, progress:nil, success: { (task, objc) in
        let account = UserAccount(dict: objc as! [String:AnyObject])
        account.loadUserInfo({ (account, error) in
            account?.saveAccount()
            NSNotificationCenter.defaultCenter().postNotificationName(SwitchRootViewController, object: false)
        })
        }) { (task, error) in
            NJLog(error)
        }
    }
}