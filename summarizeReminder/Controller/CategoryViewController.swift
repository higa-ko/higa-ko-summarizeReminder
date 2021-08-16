//
//  ViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

struct Item {
    var category: String
    var task: [String]
    var alert: Bool
}

//UITableViewController
//UIViewController

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //下にあるボタン
    @IBOutlet private weak var underButton: UIButton!
    
    private var index: Int?
    private let shaer = Share()

    //画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        //ボタンの書式を変更
        shaer.buttonOutlet(button: underButton)
    }

    //配列を定義
    private let itemArray: [Item] = [
        Item(category: "今日やること", task: ["腕立て","腹筋"], alert: true),
        Item(category: "買い物", task: ["肉","魚","野菜"], alert: true),
        Item(category: "明日やること", task: [], alert: false),
    ]
    
    
    //別画面へ数値の受け渡し
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.SegueIdentifier.CategoryToTask {
            let taskVC = segue.destination as! TaskViewController
            
            if index != nil {
                taskVC.categoryName = itemArray[index!].category
                taskVC.taskArrey = itemArray[index!].task
            }
        }
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
    
    //セルを選択した時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        index = indexPath.row

        return indexPath
    }
}

