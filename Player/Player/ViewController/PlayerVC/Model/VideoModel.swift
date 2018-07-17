//
//  VideoModel.swift
//  Player
//
//  Created by Easy on 2017/12/11.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit
@objcMembers
class VideoModel: NSObject ,ECoreDataModel{
    var uid: String = ""
    var type: String?
    var name:String?
    var localUrl:String?
}

extension VideoModel:PlayerViewModel{
    var playerUrl: String{
        return self.localUrl!
    }
    var playerName:String?{
        return self.name
    }
}
