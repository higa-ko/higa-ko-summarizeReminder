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
    var taskCheck: [Bool]
    var alert: Bool
}

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //AppDelegateの呼び出し
    private let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
    
//    //画面推移の時の処理 【一旦無効化】
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        //タスク画面へ数値の受け渡し
//        if segue.identifier == K.SegueIdentifier.CategoryToTask {
//            let taskVC = segue.destination as! TaskViewController
//
//            if index != nil {
//                //タスクビューに　カテゴリー名・タスク一覧・タスクの選択状態を渡す
//                taskVC.categoryName = itemArray[index!].category
//                taskVC.taskArrey = itemArray[index!].task
//                taskVC.taskCheck = itemArray[index!].taskCheck
//            }
//        }
//    }
    
    //別画面からカテゴリー画面へ戻ってくる
    @IBAction private func exitCancel(segue: UIStoryboardSegue) {
    }
    
    //表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegate.itemArray.count
    }
    
    //セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = K.CellIdentifier.CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! CategoryTableViewCell
        let item = delegate.itemArray[indexPath.row]
        
        cell.configure(item: item)
        
        return cell
    }
    
    //セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        delegate.categoryIndex = indexPath.row
        
        performSegue(withIdentifier: K.SegueIdentifier.CategoryToTask, sender: nil)
    }
}
