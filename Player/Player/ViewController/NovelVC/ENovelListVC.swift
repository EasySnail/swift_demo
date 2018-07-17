//
//  ENovelListVC.swift
//  Player
//
//  Created by Easy on 2017/12/13.
//  Copyright © 2017年 Easy. All rights reserved.
//

import UIKit

class ENovelListVC: EViewController {

    var tableView:UITableView!
    lazy var dataArray:Array<NovelListModel> = Array()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "小说"

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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNovel))
    }
    func loadData(){
        DataManager.getNovelList { (data) in
            self.dataArray.append(contentsOf: data)
            if (self.dataArray.count == 0){
                let md = NovelListModel()
                md.url = "http://www.250sy.cc/xiaoshuo/7/7612/8258988.html";
                md.name = "绝世剑神";
                md.uid = md.url.md5_string;
                self.dataArray.append(md)
            }
        }
    }
    @objc func addNovel(){
        let alert = UIAlertController(title: "添加", message: nil, preferredStyle: .alert)
        alert.addTextField { (tf) in
            tf.placeholder = "名称"
            tf.clearButtonMode = .whileEditing
        }
        alert.addTextField { (tf) in
            tf.placeholder = "地址"
            tf.clearButtonMode = .whileEditing
        }
        alert.addAction(UIAlertAction(title: "确定", style: .cancel, handler: {[weak self] (ac) in
            if let name = alert.textFields?.first?.text, let url = alert.textFields?.last?.text{
                if name.count > 0 && url.count > 0{
                    let md = NovelListModel()
                    md.url = url;
                    md.name = name;
                    md.uid = url.md5_string;
                    DataManager.saveNovel([md]) {}
                    self?.dataArray.append(md)
                    self?.tableView.reloadData()
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ENovelListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       cell.textLabel?.text = dataArray[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //删除
        let md = dataArray[indexPath.row]
        DataManager.deleteNovel(md.uid)
        dataArray.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NovelDetailVC()
        vc.model = dataArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
