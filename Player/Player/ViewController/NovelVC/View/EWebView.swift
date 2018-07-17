//
//  EWebView.swift
//  Player
//
//  Created by Easy on 2017/12/13.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit
import WebKit

class EWebView: WKWebView {
    //进度条偏移
    var progressOffsetY:CGFloat?{
        didSet{
            progress.e_y = progressOffsetY!
        }
    }
    //显示进度 ,默认true
    var showProgress = true
    //js调oc方法名
    var scriptNames:Array<String>?
    //获取标题
    var webViewDidGetTitleBlock:((_ title:String?)->Void)?
    //加载开始
    var webViewDidStartBlock:((_ webView:WKWebView)->Void)?
    //加载结束
    var webViewDidEndBlock:((_ webView:WKWebView)->Void)?
    //js调oc方法名Block
    private var scriptMessageHandlerBlock:((_ funcName:String, _ body:Any?)->Void)?
    
    private var progress = UIProgressView()
    /*oc调用js方法
     self.evaluateJavaScript(_)
     */

    //js调oc
    func registScriptMessageHandler(_ scriptName:[String], _ handelBlock:((_ funcName:String, _ body:Any?)->Void)?){
        self.scriptMessageHandlerBlock = handelBlock

        if let snames = scriptNames{
            for name in snames{
                self.configuration.userContentController.removeScriptMessageHandler(forName: name)
            }
        }
        for name in scriptName{
            self.configuration.userContentController.add(self, name: name)
        }
        self.scriptNames = scriptName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        self.navigationDelegate = self
        self.uiDelegate = self
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
        progress.frame = ERectMake(0, 0, self.e_width, 0)
        progress.trackTintColor = .white
        progress.progressTintColor = .red
        progress.isHidden = true
        self.addSubview(progress)
    }
    deinit {
        self.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == nil && keyPath == "estimatedProgress") {
            if (showProgress) {
                if let value =  change?[.newKey]{
                    let ps = value as! NSNumber
                    progress.progress = ps.floatValue
                    progress.isHidden = (progress.progress >= 1)
                }
            }
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if (newSuperview == nil) {
            if let snames = scriptNames{
                for name in snames{
                    self.configuration.userContentController.removeScriptMessageHandler(forName: name)
                }
            }
        }
    }
}

// MARK: -
extension EWebView:WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptMessageHandlerBlock?(message.name, message.body)
    }    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        webViewDidStartBlock?(webView)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webViewDidGetTitleBlock?(webView.title)
        webViewDidEndBlock?(webView)
    }
}
