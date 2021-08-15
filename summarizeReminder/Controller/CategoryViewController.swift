//
//  ViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

struct Item {
    var category: String
    var alert: String
    var number: String
}

//UITableViewController
//UIViewController

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //配列を定義
    private let itemArray: [Item] = [
        Item(category: "今日やること", alert: "設定あり", number: "3"),
        Item(category: "明日やること", alert: "設定なし", number: "1"),
        Item(category: "今週やること", alert: "設定なし", number: "10"),
    ]
    
    //画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = K.CellIdentifier.CategoryCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CategoryTableViewCell
        
        cell.configure(item: itemArray[indexPath.row])
        
        return cell
    }
}

