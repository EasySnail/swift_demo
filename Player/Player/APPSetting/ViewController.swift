//
//  ViewController.swift
//  Player
//
//  Created by Easy on 2017/12/7.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class ViewController: EViewController {

    var tableView:UITableView!
    lazy var dataArray:Array<String> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        loadData()
        setUpUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func setUpUI() {
        self.tableView = UITableView(frame: ERectMake(0, 0, KSCREENWIDTH, KSCREENEHEIGHT), style: .grouped)
        tableView.register(VideoListCell.classForCoder(), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }
    func loadData(){
        self.dataArray.append("本地")
        self.dataArray.append("小说")
        self.dataArray.append("蓝牙")
        self.dataArray.append("网络")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - datasource,delegate
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = dataArray[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            self.navigationController?.pushViewController(VideoListViewController(), animated: true)
        case 1:
            self.navigationController?.pushViewController(ENovelListVC(), animated: true)
        default:
            break
        }
    }
}
