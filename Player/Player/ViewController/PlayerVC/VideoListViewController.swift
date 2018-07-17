//
//  VideoListViewController.swift
//  Player
//
//  Created by Easy on 2017/12/8.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class VideoListViewController: EViewController {

    var tableView:UITableView!
    lazy var dataArray:Array<VideoModel> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "视频"
        loadData()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    func setUpUI() {
        self.tableView = UITableView(frame: ERectMake(0, 0, KSCREENWIDTH, KSCREENEHEIGHT), style: .grouped)
        tableView.register(VideoListCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
// MARK: - 加载数据
extension VideoListViewController{
    func loadData() -> Void {
        DataManager.getVideoList({ (array) in
            self.dataArray = array
            if (self.dataArray.count == 0){
                let md = VideoModel()
                md.name = "蒲公英"
                md.localUrl = Bundle.main.path(forResource: "a1", ofType: "MP4")
                self.dataArray .append(md)
            }
            
        })
    }
}


// MARK: - datasource,delegate
extension VideoListViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoListCell
        cell.updateModel(dataArray[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc =  EPlayerViewController()
        vc.playerModel = self.dataArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //删除
        let md = dataArray[indexPath.row]
        DataManager.deleteVideo(md.uid)
        EFileManager.shareManager.deletePath(md.localUrl)
        dataArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}




