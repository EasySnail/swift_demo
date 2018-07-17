//
//  ENavigationController.swift
//  Player
//
//  Created by Easy on 2017/12/7.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class ENavigationController: UINavigationController{
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            self.interactivePopGestureRecognizer?.delegate = self
            self.delegate = self
        }
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var shouldAutorotate: Bool{
        
        return (self.topViewController?.shouldAutorotate)!
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return self.topViewController!.supportedInterfaceOrientations
    }
}



// MARK: - delegate
extension ENavigationController:UIGestureRecognizerDelegate, UINavigationControllerDelegate{
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if animated {self.interactivePopGestureRecognizer?.isEnabled = false}
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"nv_back"), style: .plain, target: self, action: #selector(backClick))
        }
        super.pushViewController(viewController, animated: animated)
    }
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.interactivePopGestureRecognizer?.isEnabled = navigationController .responds(to: #selector(getter: interactivePopGestureRecognizer)) && self.viewControllers.count > 1
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let ok = true
        return ok;
    }
    @objc func backClick(){
        if let vc = self.topViewController as? ENavigationDelegate{
            vc.backClick()
        }else{
            self.popViewController(animated: true)
        }
    }
}




// MARK: - ENavigationDelegate
protocol ENavigationDelegate{
    func backClick()
}
extension ENavigationDelegate{
    func backClick(){
        if let vc = self as? UIViewController{
            vc.navigationController?.popViewController(animated: true)
        }
    }
}
