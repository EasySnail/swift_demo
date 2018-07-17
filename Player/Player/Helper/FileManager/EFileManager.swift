//
//  EFileManager.swift
//  Player
//
//  Created by Easy on 2017/12/11.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class EFileManager: NSObject {
    static let shareManager = EFileManager()
    
    let VIDEOPATH = "EVideoCache"
    let DOCPATH = NSHomeDirectory() + "/Documents/"
    override init() {
        super.init()
    }
}



// MARK: - public
extension EFileManager{
    func initFilePath() {
        let fileManager = FileManager.default
        //创建文件夹
        let docPath = DOCPATH + VIDEOPATH
        try! fileManager.createDirectory(atPath: docPath, withIntermediateDirectories: true, attributes: nil)
        
        moveVideoPath()
    }
    
    func deletePath(_ path:String?) {
        let fileManager = FileManager.default
        if let path = path{
            try? fileManager.removeItem(atPath: path)
        }
    }
    
    func moveVideoPath() {
        let fileManager = FileManager.default
        let contents = try! fileManager.contentsOfDirectory(atPath: DOCPATH)
        for file in contents {
            if fileIsVideo(file).0{
                let atPath = DOCPATH + file
                let toPath = DOCPATH + VIDEOPATH + "/" + file
                try? fileManager.moveItem(at: URL(fileURLWithPath: atPath), to: URL(fileURLWithPath: toPath))
            }
        }
        saveToCoreData()
    }
    
    func fileIsVideo(_ file:String) -> (Bool,String?) {
        for type in [".AVI",".MP4",".RM",".RMVB",".MKV",".WMV",".MOV",".FLV",".MPEG"]{
            if file.uppercased().hasSuffix(type){
                return (true, type)
            }
        }
        return (false, nil)
    }
    //保存到数据库
    func saveToCoreData(){
        let fileManager = FileManager.default
        let contents = try! fileManager.contentsOfDirectory(atPath: DOCPATH+VIDEOPATH)
        var array = Array<VideoModel>()
        for file in contents {
            let path = DOCPATH + VIDEOPATH + "/" + file
            let md = VideoModel()
            md.type = fileIsVideo(file).1
            md.name = "\(file.prefix(file.count - (md.type?.count ?? 0)))"
            md.localUrl = path
            md.uid = file.md5_string
            array.append(md)
        }
        DataManager.save(array) {}
    }
}
