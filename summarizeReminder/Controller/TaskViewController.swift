//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!
    
    //AppDelegateの呼び出し
    private let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //構造体の呼び出し
    private let shaer = Share()
    
    //画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ボタンの書式を変更
        shaer.buttonOutlet(button: addButton)
        shaer.buttonOutlet(button: deleteButton)
        
        //ナビゲーションバーのタイトルをカテゴリーに変更
        self.navigationItem.title = delegate.itemArray[delegate.categoryIndex!].category
    }
    
    //表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate.itemArray[delegate.categoryIndex!].task.count
    }
    
    //セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = K.CellIdentifier.TaskyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let text =  NSMutableAttributedString(string: delegate.itemArray[delegate.categoryIndex!].task[indexPath.row])

        //タスクの選択状態を確認して処理を分岐
        if delegate.itemArray[delegate.categoryIndex!].taskCheck[indexPath.row] {
            //タスクに訂正線を消す
            text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, text.length))
            cell.textLabel?.attributedText = text
            cell.imageView?.image = UIImage(systemName: "circle")
        } else {
            //タスクに訂正線を入れる
            text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, text.length))
            cell.textLabel?.attributedText = text
            cell.imageView?.image = UIImage(systemName: "largecircle.fill.circle")
        }
        return cell
    }
    
    //セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //ボタンをタップした時にセルの選択除隊を逆転させる
        delegate.itemArray[delegate.categoryIndex!].taskCheck[indexPath.row] = !delegate.itemArray[delegate.categoryIndex!].taskCheck[indexPath.row]
        
        //タップしたセルのみを更新
        let indexPaths = [IndexPath(row: indexPath.row, section: 0)]
        tableView.reloadRows(at: indexPaths, with: .fade)
    }
}
