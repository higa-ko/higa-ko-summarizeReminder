//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var categoryName: String?
    var taskArrey: [String] = []
    
    //画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバーのタイトルをカテゴリーに変更
        self.navigationItem.title = categoryName
    }
    
    //表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArrey.count
    }
    
    //セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = K.CellIdentifier.TaskyCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.textLabel?.text = taskArrey[indexPath.row]
        
        return cell
    }
}
