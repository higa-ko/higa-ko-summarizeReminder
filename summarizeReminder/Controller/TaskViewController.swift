//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!

    private var optionCheck = true
    private var cellArray: [TaskTableViewCell] = []

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // 構造体の呼び出し
    private let shaer = Buttonformat()

    // 画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self

        // ボタンの書式を変更
        shaer.underButtonformat(button: deleteButton)
        shaer.underButtonformat(button: addButton)

        // バーボタンを無効化
        doneButtonItem.isEnabled = false

        // ナビゲーションバーのタイトルをカテゴリーに変更
        self.navigationItem.title = appDelegate!.itemArray[appDelegate!.categoryIndex!].category
        print("タスクビューを表示")
    }

    // バーボタン(完了)
    @IBAction func doneActionButtonItem(_ sender: UIBarButtonItem) {

        print("-------バーボタン（完了）--------")
        for number in 0 ..< cellArray.count {
            let text = cellArray[number].taskText()
            guard let elementCount = appDelegate?.itemArray[(appDelegate?.categoryIndex)!].task.count else { return }

            if elementCount > number {
                appDelegate?.itemArray[(appDelegate?.categoryIndex)!].task[number] = text
            } else {
                appDelegate?.itemArray[(appDelegate?.categoryIndex)!].task.append(text)
                appDelegate?.itemArray[(appDelegate?.categoryIndex)!].isTaskCheck.append(true)
            }
            print(text)
        }

        cellArray = [] // Cell配列を初期化

        optionCheck = true
        changeButtonStatus(check: optionCheck)
        tableView.reloadData()
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
        changeButtonStatus(check: optionCheck)
        tableView.reloadData()
    }

    func changeButtonStatus(check: Bool) {
        // 選択状態に合わせてボタンの有無を切り替え
        if check {
            deleteButton.isEnabled = true
            doneButtonItem.isEnabled = false
        } else {
            deleteButton.isEnabled = false
            doneButtonItem.isEnabled = true
        }
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

        // 選択状態かで処理を分岐
        if optionCheck {
            // appDelegateから参照しているカテゴリーのIndexを取り出す
            let index =  appDelegate!.categoryIndex!

            let identifier = K.CellIdentifier.DisplayTaskyCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell
            let text =  NSMutableAttributedString(string: appDelegate!.itemArray[index].task[indexPath.row])
            let taskCheck = appDelegate!.itemArray[index].isTaskCheck[indexPath.row]

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
                cellArray.append(cell!) // 表示しているセルを配列に入れる
            } else {
                let text = appDelegate?.itemArray[index].task[indexPath.row]
                cell?.configureInputTask(text: text!)
                appDelegate?.addTaskItems?.append(text!) // 編集前のデータを配列に格納

                cell?.taskTextFieldDelegate = self

                cellArray.append(cell!) // 表示しているセルを配列に入れる
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
        appDelegate!.itemArray[index].isTaskCheck[indexPath.row].toggle()

        // タップしたセルのみを更新
        let indexPaths = [indexPath]
        tableView.reloadRows(at: indexPaths, with: .fade)
        print("タスクタブのテーブル選択")
    }
}

// MARK: - TaskTextFieldDelegate
extension TaskViewController: TaskTextFieldDelegate {
    func changedTaskTextField() {
        // 不要そうであれば消す
    }
}
