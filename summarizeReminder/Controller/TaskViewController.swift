//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

enum Mode {
    case check(Int)
    case add(Int)
}

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!

    var mode: Mode?
    //    private var cellArray: [TaskTableViewCell?] = []
    private var existingTaskArray: [String?] = []

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // 画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()  // 空のセルの区切り線だけ消す。

        // ボタンの書式を変更
        Buttonformat().underButtonformat(button: deleteButton)
        Buttonformat().underButtonformat(button: addButton)

        // バーボタンを無効化
        doneButtonItem.isEnabled = false

        guard let mode = mode else { return }
        switch mode {
        case .check(let categoryIndex):
            // ナビゲーションバーのタイトルをカテゴリーに変更
            self.navigationItem.title = appDelegate!.itemArray[categoryIndex].category

            // cellArrayの初期化
            initializationTaskArray(categoryIndex: categoryIndex)
        default:
            print("Modeにcheck以外が指定されている")
        }
        print("タスクビューを表示")
    }

    // バーボタン(完了)
    @IBAction func doneActionButtonItem(_ sender: UIBarButtonItem) {

        print("-------バーボタン（完了）--------")

        // 配列の編集と新規追加
        guard let mode = mode else { return }
        if case .add(let categoryIndex) = mode {
            guard let existingCount = appDelegate?.itemArray[categoryIndex].task.count else { return }
            for newElementNumber in 0 ..< existingTaskArray.count where existingTaskArray[newElementNumber] != nil {
                let text = existingTaskArray[newElementNumber]

                //  タスクの既存編集か新規追加かで処理を分岐
                if existingCount > newElementNumber {
                    appDelegate?.itemArray[categoryIndex].task[newElementNumber] = text!
                } else {
                    appDelegate?.itemArray[categoryIndex].task.append(text!)
                    appDelegate?.itemArray[categoryIndex].isTaskCheck.append(true)
                }
            }
            // タスクが空白になっているものを削除
            ProcessArray().deleteTaskBlank(categoryIndex: categoryIndex)

            // Cell配列を初期化
            initializationTaskArray(categoryIndex: categoryIndex)
        }
        changeMode(mode: mode)
        tableView.reloadData()
    }

    // タスク削除ボタン
    @IBAction func deleteActionButton(_ sender: UIButton) {
        // アラート作成
        let alert = UIAlertController(title: "タスク削除", message: "チェックされているタスクを全て削除します", preferredStyle: .alert)

        // ボタンの作成、追加
        let deleteButton = UIAlertAction(title: "削除", style: .destructive) { _ in

            guard let mode = self.mode else { return }
            if case .check(let categoryIndex) = mode {
                ProcessArray().deleteTaskCheck(categoryIndex: categoryIndex) // タスクの削除処理
                self.initializationTaskArray(categoryIndex: categoryIndex) // cellArrayの初期化
            }

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
        guard let mode = mode else { return }
        changeMode(mode: mode)
        tableView.reloadData()
    }

    private func changeMode(mode: Mode) {
        // 選択状態に合わせてボタンの有無を切り替え
        switch mode {
        case .check(let categoryIndex):
            self.mode = .add(categoryIndex)
            deleteButton.isEnabled = false
            addButton.isEnabled = false
            doneButtonItem.isEnabled = true
        case .add(let categoryIndex):
            self.mode = .check(categoryIndex)
            deleteButton.isEnabled = true
            addButton.isEnabled = true
            doneButtonItem.isEnabled = false
        }
    }

    // existingTaskArray配列の初期化
    private func initializationTaskArray(categoryIndex: Int) {
        guard let existingCount = appDelegate?.itemArray[categoryIndex].task.count else { return }
        existingTaskArray = []
        // 要素の数+1分配列にnilを追加
        for _ in 0 ... existingCount {
            existingTaskArray.append(nil)
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // 選択されているモードに合わせてセルの表示数を変更
        switch mode {
        case .check:
            return existingTaskArray.count - 1
        case .add:
            return existingTaskArray.count
        default:
            print("存在しないモードが選択されている")
            return 0
        }
    }

    // セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 選択されているモードに合わせてセルの表示内容を変更
        switch mode {
        case .check(let categoryIndex):
            let identifier = K.CellIdentifier.DisplayTaskyCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell
            let text =  NSMutableAttributedString(string: appDelegate!.itemArray[categoryIndex].task[indexPath.row])
            let isTaskCheck = appDelegate!.itemArray[categoryIndex].isTaskCheck[indexPath.row]

            // 表示用のセルを表示
            cell?.configureDisplayTask(text: text, isTaskCheck: isTaskCheck)

            return cell!

        case .add(let categoryIndex):
            let identifier = K.CellIdentifier.InputTaskCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell
            let max = existingTaskArray.count
            let text: String?

            // セルが再利用のものか確認
            if existingTaskArray[indexPath.row] == nil {

                // 最後のセルのみ表示処理を変更
                if max - 1 == indexPath.row {
                    text = ""
                    existingTaskArray[indexPath.row] = text
                    cell?.inputTaskTextField.becomeFirstResponder() // 最後のテキストフィールドにフォーカス
                } else {
                    text = appDelegate?.itemArray[categoryIndex].task[indexPath.row]
                    existingTaskArray[indexPath.row] = text // 表示しているセルを配列に入れる
                }

            } else {
                text = existingTaskArray[indexPath.row]
            }

            cell?.configureInputTask(text: text!)
            cell?.taskTextFieldDelegate = self

            return cell!

        default:
            print("存在しないモードが選択されている")
            let identifier = K.CellIdentifier.InputTaskCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell
            return cell!
        }
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch mode {
        case .check:
            return indexPath // セルを選択可能に変更
        case .add:
            print("\(indexPath.row)")
            return nil // セルを選択不可に変更
        default:
            print("存在しないモードが選択されている")
            return nil // セルを選択不可に変更
        }
    }

    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let mode = mode else { return }
        if case .check(let categoryIndex) = mode {
            // ボタンをタップした時にセルの選択除隊を逆転させる
            appDelegate!.itemArray[categoryIndex].isTaskCheck[indexPath.row].toggle()
        }

        // タップしたセルのみを更新
        tableView.reloadRows(at: [indexPath], with: .fade)
        print("タスクタブのテーブル選択")
    }

    // セルを削除(タスク削除)
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            guard let mode = self.mode else { return }
            if case .check(let categoryIndex) = mode {
                appDelegate?.itemArray[categoryIndex].task.remove(at: indexPath.row)
                initializationTaskArray(categoryIndex: categoryIndex) // cellArrayの初期化
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }

    // セルの削除許可を設定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        switch mode {
        case .check:
            return true
        case .add:
            return false
        case .none:
            print("存在しないモードが選択されている")
            return false
        }
    }

}

// MARK: - TaskTextFieldDelegate
extension TaskViewController: TaskTextFieldDelegate {
    func changedTextField(cell: TaskTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        let text = cell.inputTaskTextField.text
        existingTaskArray[indexPath!.row] = text
    }

    func endActionTextField() {
        print("改行が押された時")
    }
}
