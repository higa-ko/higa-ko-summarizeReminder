//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var categoryName: String?
    var taskArrey: [String] = []
    private let shaer = Share()
    
    //画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンの書式を変更
        shaer.buttonOutlet(button: addButton)
        shaer.buttonOutlet(button: deleteButton)
        
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
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let identifier = K.CellIdentifier.TaskyCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let text =  NSMutableAttributedString(string: "テスト")
        
        //Value: 11など指定すると二重取消線になる
        text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, text.length))
        
        cell.textLabel?.attributedText = text
        
        print("タスクセルタップ")
        print(text)
    }
    
}
