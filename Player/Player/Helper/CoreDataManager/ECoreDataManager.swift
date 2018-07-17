//
//  ECoreDataManager.swift
//  Player
//
//  Created by Easy on 2017/12/11.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit
import CoreData

// MARK: - model   子类需要加@objcMembers
protocol ECoreDataModel {
    var uid:String{get set}
    func value(forKey key: String) -> Any?
}

// MARK: - 数据库表
public enum EEntityName : String {
    case videoEntity = "VideoEntity"
    case novelEntity = "NovelEntity"
}
// MARK: - 数据库表字段方法
extension ECoreDataManager{
    func entityKeys(_ entityName:EEntityName) -> Array<String> {
        switch entityName {
        case .videoEntity:
            return ["uid","name","localUrl","type"]
        case .novelEntity:
            return ["uid","name","url","historyUrl"]
        }
    }
}


class ECoreDataManager: NSObject {
    static let shared = ECoreDataManager()
    lazy var persistentContainer = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    lazy var mainContentex = {
        return persistentContainer.viewContext
    }()
    
    func save(_ data:Array<ECoreDataModel>, _ existUpdate:Bool, _ entityName:EEntityName,_ handelBlock:@escaping (() -> Void)){
        persistentContainer.performBackgroundTask { (context) in
            let allKeys = self.entityKeys(entityName)
            for i in data{
                var manageObject:NSManagedObject?
                if existUpdate{
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
                    fetchRequest.predicate = NSPredicate(format: "uid == %@", i.uid)
                    let array = try? context.fetch(fetchRequest)
                    if let md = array?.first{
                        manageObject = md as? NSManagedObject
                    }
                }
                if (manageObject == nil){
                    manageObject = NSEntityDescription.insertNewObject(forEntityName: entityName.rawValue, into: context)
                }
                for key in allKeys{
                    if let value = i.value(forKey: key){
                        manageObject!.setValue(value, forKey: key)
                    }
                }
            }
            try? context.save()
            handelBlock()
        }
        /*计算执行时间
        let starTime = CFAbsoluteTimeGetCurrent()
        //code
        let linkTime = (CFAbsoluteTimeGetCurrent() - starTime)
        print(linkTime)
        */
    }
    
    //查询
    func fetch(_ predicate:NSPredicate?, _ modelClass:String, _ entityName:EEntityName, _ handelBlock:(_ dataArray:Array<Any>)->Void){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        if (predicate != nil) {
            fetchRequest.predicate = predicate
        }
        //分页
        //fetchRequest.fetchLimit = 10
        //fetchRequest.fetchOffset = 1
        var dataArray = Array<Any>()
        if let array = try? mainContentex.fetch(fetchRequest) as! Array<NSManagedObject> {
            let allKeys = self.entityKeys(entityName)
            let typeClass = NSClassFromString("\(ENameSpace)." + modelClass) as! NSObject.Type
            for obj in array{
                let md = typeClass.init()
                for key in allKeys{
                    md.setValue(obj.value(forKey: key), forKey: key)
                }
                dataArray.append(md)
            }
        }
        handelBlock(dataArray)
    }
    
    //删除
    func delete(_ predicate:NSPredicate, _ entityName:EEntityName){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        fetchRequest.predicate = predicate
        if let array = try? mainContentex.fetch(fetchRequest) as! Array<NSManagedObject>{
            for objct in array{
                mainContentex.delete(objct)
            }
            try? mainContentex.save()
        }
    }
}









