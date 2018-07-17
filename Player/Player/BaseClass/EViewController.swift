//
//  EViewController.swift
//  Player
//
//  Created by Easy on 2017/12/7.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class EViewController: UIViewController, ENavigationDelegate {


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}

