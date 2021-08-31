//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!

    private var optionCheck = true

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // 構造体の呼び出し
    private let shaer = Buttonformat()

    // 画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        // ボタンの書式を変更
        shaer.underButtonformat(button: deleteButton)
        shaer.underButtonformat(button: addButton)

        // ナビゲーションバーのタイトルをカテゴリーに変更
        self.navigationItem.title = appDelegate!.itemArray[appDelegate!.categoryIndex!].category
    }

    // タスク削除ボタン
    @IBAction func deleteActionButton(_ sender: UIButton) {
        // アラート作成
        let alert = UIAlertController(title: "タスク削除", message: "チェックされているタスクを全て削除します", preferredStyle: .alert)

        // ボタンの作成、追加
        let deleteButton = UIAlertAction(title: "削除", style: .destructive) { _ in
            ProcessArray().deleteTask() // タスクの削除処理
            self.tableView.reloadData()
        }
        alert.addAction(deleteButton)
        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(cancelButton)

        // アラートの表示
        present(alert, animated: true, completion: nil)
    }

    // タスク追加ボタン
    @IBAction func addActionButton(_ sender: UIButton) {
        optionCheck = !optionCheck
        tableView.reloadData()

        // 選択状態に合わせて削除ボタンの有効/無効
        deleteButton.isEnabled = optionCheck ? true : false
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 選択状態に応じてセルの表示数を変更
        let number = optionCheck ? 0 : 1
        return appDelegate!.itemArray[appDelegate!.categoryIndex!].task.count + number
    }

    // セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if optionCheck {
            // appDelegateから参照しているカテゴリーのIndexを取り出す
            let index =  appDelegate!.categoryIndex!

            let identifier = K.CellIdentifier.DisplayTaskyCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell
            let text =  NSMutableAttributedString(string: appDelegate!.itemArray[index].task[indexPath.row])
            let taskCheck = appDelegate!.itemArray[index].taskCheck[indexPath.row]

            // 表示用のセルを表示
            cell?.configureDisplayTask(text: text, taskCheck: taskCheck)

            return cell!
        } else {
            // appDelegateから参照しているカテゴリーのIndexを取り出す
            let index =  appDelegate!.categoryIndex!

            let identifier = K.CellIdentifier.InputTaskCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell
            let max = appDelegate!.itemArray[appDelegate!.categoryIndex!].task.count

            // 最後のセルのみ表示処理を変更
            if max == indexPath.row {
                cell?.configureInputTask(text: "")
            } else {
                let text = appDelegate?.itemArray[index].task[indexPath.row]
                cell?.configureInputTask(text: text!)
            }

            return cell!
        }
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if optionCheck {
            return indexPath // セルを選択可能に変更
        } else {
            return nil // セルを選択不可に変更
        }
    }

    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // appDelegateから参照しているカテゴリーのIndexを取り出す
        guard let index = appDelegate!.categoryIndex else { return }

        // ボタンをタップした時にセルの選択除隊を逆転させる
        appDelegate!.itemArray[index].taskCheck[indexPath.row] = !appDelegate!.itemArray[index].taskCheck[indexPath.row]

        // タップしたセルのみを更新
        let indexPaths = [IndexPath(row: indexPath.row, section: 0)]
        tableView.reloadRows(at: indexPaths, with: .fade)
        print("タスクタブのテーブル選択")
    }
}
