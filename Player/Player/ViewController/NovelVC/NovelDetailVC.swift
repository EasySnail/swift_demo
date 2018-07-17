//
//  NovelDetailVC.swift
//  Player
//
//  Created by Easy on 2017/12/13.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class NovelDetailVC: EViewController {
    var model:NovelListModel?
    lazy var webView = EWebView(frame: ERectMake(0, 0, KSCREENWIDTH, KSCREENEHEIGHT))
    
    lazy var refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    lazy var saveItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(save))
    lazy var goForwardItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(goForward))
    lazy var goBackwardItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(goBackward))
    
    lazy var goOriginItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(goOrigin))
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        

//        DataManager.saveNovel([md])
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        self.navigationItem.rightBarButtonItems = [refreshItem,saveItem]
        
        var array = self.navigationItem.leftBarButtonItems
        array?.append(goOriginItem)
        self.navigationItem.leftBarButtonItems = array;
        self.view.addSubview(webView)
        webView.configuration.preferences.javaScriptEnabled = false
        webView.progressOffsetY = kNavigationHeight
        
        
        let re = URLRequest(url: URL(string:model?.historyUrl ?? model!.url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        webView.load(re)
        webView.webViewDidEndBlock = {[weak self] (wb) in
            let list = wb.backForwardList
            var itemArray:[UIBarButtonItem]?
            switch (list.backList.count, list.forwardList.count) {
            case (0, 0):
                itemArray = [self!.refreshItem,self!.saveItem]
            case (0, let b) where b > 0:
                itemArray = [self!.refreshItem,self!.saveItem,self!.goForwardItem]
            case (let a, 0) where a > 0:
                itemArray = [self!.refreshItem,self!.saveItem,self!.goForwardItem,self!.goBackwardItem]
            case let(a, b) where a > 0 && b > 0:
                itemArray = [self!.refreshItem,self!.saveItem,self!.goForwardItem,self!.goBackwardItem]
            default:
                break
            }
            self?.navigationItem.rightBarButtonItems = itemArray
            
            
            
            self?.model?.historyUrl = wb.url?.absoluteString;
            if let md = self?.model {
                DataManager.saveNovel([md], {
                    
                });
            }
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - NavigationBarItemClick
extension NovelDetailVC{
    
    
    
    
    @objc func goOrigin() {
        let re = URLRequest(url: URL(string:model?.url ?? model!.url)!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60)
        webView.load(re)
    }
    @objc func refresh() {
        webView.reload()
    }
    @objc func goForward() {
        if webView.canGoForward{
            webView.goForward()
        }
    }
    @objc func goBackward() {
        if webView.canGoBack{
            webView.goBack()
        }
    }
    @objc func save() {
        webView.configuration.preferences.javaScriptEnabled = !webView.configuration.preferences.javaScriptEnabled
        self.refresh()
    }
}
