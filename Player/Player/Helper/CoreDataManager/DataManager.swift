//
//  DataManager.swift
//  Player
//
//  Created by Easy on 2017/12/11.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit


class DataManager: NSObject {

}

// MARK: -video数据库操作
extension DataManager{
    
    //插入视频
    class func save(_ data:Array<VideoModel>, _ handelBlock:@escaping (() -> Void)) {
        ECoreDataManager.shared.save(data, true, .videoEntity, handelBlock)
    }
    
    //查询所有
    class func getVideoList(_ handelBlock:((_ data:Array<VideoModel>) -> Void)) {
        ECoreDataManager.shared.fetch(nil, "VideoModel", .videoEntity) { (dataArray ) in
            handelBlock(dataArray as! Array<VideoModel>)
        }
    }
    //删除
    class func deleteVideo(_ uid:String) {
        ECoreDataManager.shared.delete(NSPredicate(format: "uid == %@", uid), .videoEntity)
    }
}


// MARK: -novel数据库操作
extension DataManager{
    //添加
    class func saveNovel(_ data:Array<NovelListModel>, _ handelBlock:@escaping (() -> Void)) {
        ECoreDataManager.shared.save(data, true, .novelEntity, handelBlock)
    }
    //删除
    class func deleteNovel(_ uid:String) {
        ECoreDataManager.shared.delete(NSPredicate(format: "uid == %@", uid), .novelEntity)
    }
    //查询所有
    class func getNovelList(_ handelBlock:((_ data:Array<NovelListModel>) -> Void)) {
        ECoreDataManager.shared.fetch(nil, "NovelListModel", .novelEntity) { (dataArray ) in
            handelBlock(dataArray as! Array<NovelListModel>)
        }
    }
}

