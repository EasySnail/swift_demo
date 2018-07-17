//
//  EPlayerViewController.swift
//  Player
//
//  Created by Easy on 2017/12/7.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit


protocol PlayerViewModel:NSObjectProtocol {
    var playerUrl:String {get}
    var playerName:String? {get}
}
extension PlayerViewModel{
    var playerName:String? {
        return ""
    }
}

class EPlayerViewController: EViewController {
    
    weak open var playerModel: PlayerViewModel?
    /*
    let PalyerHeight = KSCREENWIDTH * 0.5625
    private var isLandscape:Bool = false                     //是否是横屏
    
    lazy var playerView = {
        return PlayerView(frame:ERectMake(0, 0, KSCREENWIDTH, PalyerHeight))
    }()
    lazy var player:VLCMediaPlayer = {
        return VLCMediaPlayer(options: nil)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if playerModel != nil{
            setUpUI()
        }
        // Do any additional setup after loading the view.
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return isLandscape ? .landscapeRight : .portrait
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        player.stop()
    }
 */
}

/*

// MARK: - 设置UI
extension EPlayerViewController{
    func setUpUI(){
        self.view.addSubview(playerView)
        playerView.setVideoName(playerModel?.playerName)
        player.drawable = playerView.contentView
        player.media = VLCMedia(path: playerModel!.playerUrl)
        player.delegate = self
        //操作事件BLock
        //点击播放
        playerView.playBlock = { [weak self] isPlayer in
            if isPlayer {
                if !self!.player.isPlaying{
                    self?.player.play()
                }
            }else{
                if self!.player.canPause{
                    self?.player.pause()
                }
            }
        }
        //点击缩放
        playerView.scaleBlock = { [weak self] isScale in
            self!.isLandscape = !self!.isLandscape
            self!.interfaceOrientation()
        }
        //seek to指定位置
        playerView.seekBlock = {[weak self] position in
            if self!.player.isSeekable{
                self!.player.position = position
            }
        }
        //前进
        playerView.jumpForwardBlock = {[weak self] second in
            if self!.player.isSeekable{
                self?.player.jumpForward(second)
            }
        }
        //后退
        playerView.jumpBackwardBlock = {[weak self] second in
            if self!.player.isSeekable{
                self?.player.jumpBackward(second)
            }
        }
        //点击返回
        playerView.backBlock = {[weak self] back in
            if self!.isLandscape {
                self!.isLandscape = !self!.isLandscape
                self!.interfaceOrientation()
            }else{
                self!.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.playerView.frame = ERectMake(0, 0, size.width, self.isLandscape ? size.height : self.PalyerHeight)
            self.playerView.frameChanged()
        }, completion: nil)
    }
    //设置横竖屏幕
    func interfaceOrientation(){
        let orientationUnknown = NSNumber(integerLiteral: UIInterfaceOrientation.unknown.rawValue)
        UIDevice.current.setValue(orientationUnknown, forKey: "orientation")
        let integerLiteral:UIInterfaceOrientation = isLandscape ? .landscapeRight : .portrait
        let orientationTarget = NSNumber(integerLiteral: integerLiteral.rawValue)
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }    
}

// MARK: - player协议
extension EPlayerViewController:VLCMediaPlayerDelegate{
    //播放状态变化
    func mediaPlayerStateChanged(_ aNotification: Notification!) {
        switch self.player.state {
        case .stopped:
            self.playerView.playerButton.e_selected = false
            self.player.stop()
        default:break
        }
    }
    //时间变化
    func mediaPlayerTimeChanged(_ aNotification: Notification!) {
        self.playerView.setTime(self.player.time, self.player.media.length)
    }
}

*/

