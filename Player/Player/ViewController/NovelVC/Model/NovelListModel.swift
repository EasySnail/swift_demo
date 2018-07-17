//
//  NovelListModel.swift
//  Player
//
//  Created by Easy on 2017/12/13.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

@objcMembers
class NovelListModel: NSObject, ECoreDataModel {
    var uid: String = ""
    var name:String?
    var url:String = ""
    var historyUrl:String?
}
