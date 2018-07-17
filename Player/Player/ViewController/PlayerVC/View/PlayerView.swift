//
//  PlayerView.swift
//  Player
//
//  Created by Easy on 2017/12/7.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    var playBlock:((_ isPlay:Bool)->())?{
        didSet{
            playerButton.clickBlock = playBlock
        }
    }
    var pauseBlock:((_ isPause:Bool)->())?{
        didSet{
            //scaleButton.clickBlock = oldValue
        }
    }
    var scaleBlock:((_ isScale:Bool)->())?{
        didSet{
            scaleButton.clickBlock = scaleBlock
        }
    }
    var backBlock:((_ selected:Bool)->())?{
        didSet{
            backButton.clickBlock = backBlock
        }
    }
    var seekBlock:((_ position:Float)->())?
    
    var jumpForwardBlock:((_ sencond:Int32)->())?
    var jumpBackwardBlock:((_ sencond:Int32)->())?
    
    
    
    var contentView:UIView = UIView()
    var backColorView:UIImageView = UIImageView()
    var bottomView:UIImageView = UIImageView()
    var topView:UIImageView = UIImageView()
    var playerButton:EPlayerButton = EPlayerButton()
    var scaleButton:EPlayerButton = EPlayerButton()
    var backButton:EPlayerButton = EPlayerButton()
    var titleLabel = UILabel()
    var startTimeLabel = UILabel()
    var totalTimeLabel = UILabel()
    var progress = UISlider()
    
    lazy var panStartPoint:CGPoint = .zero
    lazy var panEndPoint:CGPoint = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frameChanged()
        setUpUI()
        setGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    open func frameChanged() {
        bottomView.frame = ERectMake(0, self.frame.size.height-44, self.frame.size.width, 44)
        topView.frame = ERectMake(0, 0, self.frame.size.width, 64)
        contentView.frame = self.bounds
        backColorView.frame = self.bounds
        scaleButton.frame = ERectMake(self.frame.width-44, 0, 44, 44)
        totalTimeLabel.frame = ERectMake(self.e_width-44-totalTimeLabel.e_width, 0, totalTimeLabel.e_width, 44)
        let dw = startTimeLabel.e_x+startTimeLabel.e_width
        progress.frame = ERectMake(dw, 0, self.e_width-2*dw, 44)
    }
    deinit {
    }
}
// MARK: - 外部方法
extension PlayerView{
    open func setTime(_ start:VLCTime, _ total:VLCTime) {
        let startTime = start.stringValue
        if (self.startTimeLabel.text) != startTime {
            startTimeLabel.text = startTime
        }
        if self.totalTimeLabel.text == "00:00" {
            totalTimeLabel.text = total.stringValue
        }
        if self.progress.state == .normal{
            self.progress.value = Float(start.intValue) / Float(total.intValue)
        }
    }
    open func setVideoName(_ name:String?) {
        self.titleLabel.text = name
    }
}

// MARK: - 设置手势gestrue，点击事件
extension PlayerView{
    func setGesture() {
        //点击隐藏
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapClick))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        self.contentView.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panClick(_:)))
        self.contentView.addGestureRecognizer(pan)
    }
    @objc func tapClick() {
        let hide = !self.bottomView.isHidden
        UIView.animate(withDuration: 0.25) {
            self.bottomView.isHidden = hide
            self.topView.isHidden = hide
        }
    }
    @objc func panClick(_ pan:UIPanGestureRecognizer){
        if pan.state == .began{
            self.panStartPoint = pan.translation(in: pan.view)
        }else if pan.state == .ended{
            self.panEndPoint = pan.translation(in: pan.view)
            let dw = panEndPoint.x - panStartPoint.x
            let second = Int32(abs(dw)) / 5
            if dw > 0.0{
                //前进
                if self.jumpForwardBlock != nil{
                    jumpForwardBlock?(second)
                }
            }else{
                //后退
                if self.jumpBackwardBlock != nil{
                    jumpBackwardBlock?(second)
                }
            }
        }
    }
    
    //进度条变化结束
    @objc func progressValueChanged(){
        if (self.seekBlock != nil) {
            self.seekBlock?(progress.value)
        }
    }
}

// MARK: - 设置UI
extension PlayerView{
    func setUpUI() {
        contentView.frame = self.bounds
        self.addSubview(backColorView)
        self.addSubview(contentView)
        self.addSubview(bottomView)
        self.addSubview(topView)
        backColorView.image = UIImage(named:"player_BackImage")
        bottomView.image = UIImage(named: "tooBar_bg_image")
        bottomView.isUserInteractionEnabled = true
        topView.image = UIImage(named: "tooBar_bg1_image")
        topView.isUserInteractionEnabled = true
        
        
        playerButton.e_images = ["player_play","player_pause"]
        playerButton.frame = ERectMake(0, 0, 44, 44)
        playerButton.e_selected = false
        bottomView.addSubview(playerButton)
        
        scaleButton.e_images = ["player_scale1","player_scale"]
        scaleButton.frame = ERectMake(self.frame.width-44, 0, 44, 44)
        scaleButton.e_selected = false
        bottomView.addSubview(scaleButton)
        
        startTimeLabel.frame = ERectMake(44, 0, 45, 44)
        startTimeLabel.textColor = .white
        startTimeLabel.textAlignment = .center
        startTimeLabel.text = "00:00"
        startTimeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        bottomView .addSubview(startTimeLabel)
        
        totalTimeLabel.frame = ERectMake(self.e_width-44-startTimeLabel.e_width, 0, startTimeLabel.e_width, 44)
        totalTimeLabel.textColor = .white
        totalTimeLabel.text = "00:00"
        totalTimeLabel.textAlignment = .center
        totalTimeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        bottomView.addSubview(totalTimeLabel)
        
        let dw = startTimeLabel.e_x+startTimeLabel.e_width
        progress.frame = ERectMake(dw, 0, self.e_width-2*dw, 44)
        progress.addTarget(self, action: #selector(progressValueChanged), for: .touchUpInside)
        progress.minimumTrackTintColor = RGBColor(0x6BFB6D)
        progress.setThumbImage(UIImage(named:"slider_thumb"), for: .normal)
        bottomView.addSubview(progress)
        
        backButton.frame = ERectMake(0, 15, 44, 44)
        backButton.setImage(UIImage(named:"back"), for: .normal)
        topView.addSubview(backButton)
        
        titleLabel.frame = ERectMake(35, backButton.frame.origin.y, 200, backButton.frame.size.height)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        titleLabel.textColor = .white
        topView.insertSubview(titleLabel, at: 0)
    }
    
}




// MARK: - 自定义button
class EPlayerButton: UIButton {
    var e_images:Array<String>?
    var clickBlock:((_ selected:Bool)->())?
    var e_selected:Bool = false{
        willSet{
            if let _ = e_images{
                setImage(UIImage(named:(newValue ? e_images?.first : e_images?.last)!), for: .normal)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.adjustsImageWhenHighlighted = false
        self.showsTouchWhenHighlighted = true
        self.addTarget(self, action: #selector(click), for: .touchUpInside)
    }
    @objc func click() {
        e_selected = !e_selected
        clickBlock?(e_selected)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






