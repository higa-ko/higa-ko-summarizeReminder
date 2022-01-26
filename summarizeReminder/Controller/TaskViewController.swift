//
//  TaskViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

enum TaskMode {
    case check
    case add
}

enum TransitionSource {
    case categoryEdit(Int)
    case inputEdit(Int)
    case inputAdd
}

class TaskViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var doneButtonItem: UIBarButtonItem!
    @IBOutlet private weak var deleteButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!

    var taskMode: TaskMode?
    var transitionSource: TransitionSource?

    var beforeExistingItem: Item?
    private var existingTaskArray: [String?] = [] // タスクの編集内容を格納する配列　編集対象のタスク数+1の要素数

    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // 画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()  // 空のセルの区切り線だけ消す。

        // ボタンの書式を変更
        Buttonformat().underButtonformat(button: deleteButton)
        Buttonformat().underButtonformat(button: addButton)

        // ナビゲーションバーのタイトルをカテゴリーに変更
        self.navigationItem.title = beforeExistingItem?.category

        // existingTaskArrayの初期化
        initializationTaskArray()

        // 選択状態に合わせてボタンの有無を切り替え
        guard let taskMode = taskMode else { return }
        setMode(mode: taskMode)
    }

    // バーボタン(完了)
    @IBAction func doneActionButtonItem(_ sender: UIBarButtonItem) {

        // 配列の編集と新規追加
        guard let mode = taskMode else { return }
        if case .add = mode {
            guard let existingCount = beforeExistingItem?.task.count else { return }
            for newElementNumber in 0 ..< existingTaskArray.count where existingTaskArray[newElementNumber] != nil {
                let task = existingTaskArray[newElementNumber]

                //  タスクの既存編集か新規追加かで処理を分岐
                if existingCount > newElementNumber {
                    beforeExistingItem!.task[newElementNumber] = task!
                } else {
                    beforeExistingItem!.task.append(task!)
                    beforeExistingItem!.isTaskCheck.append(true)
                }
            }
            beforeExistingItem = deleteTaskBlank(item: beforeExistingItem!) // タスクが空白になっているものを削除

            initializationTaskArray() // existingTaskArray配列を初期化
            guard let item = self.beforeExistingItem else { return }
            guard let transitionSource = self.transitionSource else { return }
            shareItem(item: item, transitionSource: transitionSource)
        }
        changeMode()
        tableView.reloadData()
    }

    // タスク削除ボタン
    @IBAction func deleteActionButton(_ sender: UIButton) {
        // アラート作成
        let alert = UIAlertController(title: "タスク削除", message: "チェックされているタスクを全て削除します", preferredStyle: .alert)

        // ボタンの作成、追加
        let deleteButton = UIAlertAction(title: "削除", style: .destructive) { _ in

            guard let mode = self.taskMode else { return }
            if case .check = mode {
                self.beforeExistingItem = self.deleteTaskCheck(item: self.beforeExistingItem!) // タスクの削除処理
                self.initializationTaskArray() // existingTaskArrayの初期化

                guard let item = self.beforeExistingItem else { return }
                guard let transitionSource = self.transitionSource else { return }
                self.shareItem(item: item, transitionSource: transitionSource)
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
        changeMode()
        tableView.reloadData()

        scrollFocus()
    }

    private func changeMode() {
        switch taskMode {
        case .check:
            self.taskMode = .add
        case .add:
            self.taskMode = .check
        case .none:
            break
        }

        guard let taskMode = taskMode else { return }
        setMode(mode: taskMode)
    }

    private func setMode(mode: TaskMode) {
        // 選択状態に合わせてボタンの有無を切り替え
        switch mode {
        case .check:
            deleteButton.isEnabled = true
            addButton.isEnabled = true
            doneButtonItem.isEnabled = false
        case .add:
            deleteButton.isEnabled = false
            addButton.isEnabled = false
            doneButtonItem.isEnabled = true
        }
    }

    // タスクにチェックがついている場合配列の要素から削除
    private func deleteTaskCheck(item: Item) -> Item {
        var deleteItem = item

        let max = deleteItem.task.count // タスクの項目数を取得

        // swiftlint:disable identifier_name
        for i in 0 ..< max {
            // swiftlint:enable identifier_name
            let taskCheck = item.isTaskCheck[(max - 1) - i]

            if taskCheck {
            } else {
                deleteItem.task.remove(at: (max - 1) - i)
                deleteItem.isTaskCheck.remove(at: (max - 1) - i)
            }
        }
        return deleteItem
    }

    // タスクが空白になっている場合配列の要素から削除
    private func deleteTaskBlank(item: Item) -> Item {
        var deleteItem = item
        let max = deleteItem.task.count // タスクの項目数を取得

        // swiftlint:disable identifier_name
        // タスクの配列の後ろからタスクが空白になっているものを削除
        for i in 0 ..< max where item.task[(max - 1) - i] == ""{
        // swiftlint:enable identifier_name

            deleteItem.task.remove(at: (max - 1) - i)
            deleteItem.isTaskCheck.remove(at: (max - 1) - i)
        }
        return deleteItem
    }

    // existingTaskArray配列の初期化
    private func initializationTaskArray() {
        guard let existingCount = beforeExistingItem?.task.count else { return }
        existingTaskArray = []
        // 要素の数+1分配列にnilを追加
        for _ in 0 ... existingCount {
            existingTaskArray.append(nil)
        }
    }

    private func scrollFocus() {
        // 一番下のセルまでスクロールする
        let indexPath = IndexPath(row: existingTaskArray.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        tableView.reloadRows(at: [indexPath], with: .none) // 最後の行をリロード
        guard let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell else { return }
        cell.taskTextField.becomeFirstResponder() // 最後のセルにフォーカス
    }

    // 更新したタスクの情報をAppDelegateと元のビューコントローラに通知
    private func shareItem(item: Item, transitionSource: TransitionSource) {
        switch transitionSource {
        case .categoryEdit(let categoryIndex):
            // 既存の配列への設定変更の場合のみ処理を実行
            ProcessArray().editArray(item: item, categoryIndex: categoryIndex) // 関数呼び出し

        case .inputAdd:
            // InputTableViewControllerに値を渡す
            guard let navigation = self.navigationController else { return }
            guard let inputTVC = navigation.viewControllers[0] as? InputTableViewController else { return }
            inputTVC.addItem = item

        case .inputEdit:
            // InputTableViewControllerに値を渡す
            guard let navigation = self.navigationController else { return }
            guard let inputTVC = navigation.viewControllers[0] as? InputTableViewController else { return }
            inputTVC.editItem = item
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        // 選択されているモードに合わせてセルの表示数を変更
        guard let taskMode = taskMode else { return 0 }
        switch taskMode {
        case .check:
            return existingTaskArray.count - 1
        case .add:
            return existingTaskArray.count
        }
    }

    // セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = K.CellIdentifier.TaskCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TaskTableViewCell

        // 選択されているモードに合わせてセルの表示内容を変更
        guard let taskMode = taskMode else { return cell! }
        switch taskMode {
        case .check:
            let text =  beforeExistingItem!.task[indexPath.row]
            let isTaskCheck = beforeExistingItem!.isTaskCheck[indexPath.row]

            // 表示用のセルを表示
            cell?.configureDisplayTask(text: text, taskMode: taskMode, isTaskCheck: isTaskCheck)

            return cell!

        case .add:
            let max = existingTaskArray.count
            let text: String?

            // セルが再利用のものか確認
            if existingTaskArray[indexPath.row] == nil {

                // 最後のセルのみ表示処理を変更
                if max - 1 == indexPath.row {
                    text = ""
                    existingTaskArray[indexPath.row] = text
                    cell?.taskTextField.becomeFirstResponder() // 最後のセルにフォーカス
                } else {
                    text = beforeExistingItem!.task[indexPath.row]
                    existingTaskArray[indexPath.row] = text // 表示しているセルを配列に入れる
                }

            } else {
                text = existingTaskArray[indexPath.row]!
            }

            cell?.configureDisplayTask(text: text!, taskMode: taskMode, isTaskCheck: true)
            cell?.taskTextFieldDelegate = self

            return cell!
        }
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let taskMode = taskMode else { return nil }
        switch taskMode {
        case .check:
            return indexPath // セルを選択可能に変更
        case .add:
            return nil // セルを選択不可に変更
        }
    }

    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let taskMode = taskMode else { return }
        if case .check = taskMode {
            // ボタンをタップした時にセルの選択除隊を逆転させる
            beforeExistingItem!.isTaskCheck[indexPath.row].toggle()

            guard let item = self.beforeExistingItem else { return }
            guard let transitionSource = self.transitionSource else { return }
            shareItem(item: item, transitionSource: transitionSource)
        }

        // タップしたセルのみを更新
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    // セルを削除(タスク削除)
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            guard let mode = self.taskMode else { return }
            if case .check = mode {
                beforeExistingItem!.task.remove(at: indexPath.row)
                beforeExistingItem!.isTaskCheck.remove(at: indexPath.row)
                initializationTaskArray() // existingTaskArrayの初期化
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        guard let item = self.beforeExistingItem else { return }
        guard let transitionSource = self.transitionSource else { return }
        shareItem(item: item, transitionSource: transitionSource)
    }

    // セルの削除許可を設定
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        guard let taskMode = taskMode else { return false }
        switch taskMode {
        case .check:
            return true
        case .add:
            return false
        }
    }

}

// MARK: - TaskTextFieldDelegate
extension TaskViewController: TaskTextFieldDelegate {

    // テキストフィールドが編集された時の処理
    func changedTextField(cell: TaskTableViewCell) {
        guard let mode = taskMode else { return }
        if case .add = mode {

            guard let indexPath = tableView.indexPath(for: cell) else { return }
            guard let task = cell.taskTextField.text  else { return }
            existingTaskArray[indexPath.row] = task
        }
    }

    // 改行が押された時の処理
    func endActionTextField() {
        // 編集用の配列の最後が空白かどうかで処理を分岐
        guard let mode = taskMode else { return }
        if case .add = mode {

            if existingTaskArray.last! != "" {
                existingTaskArray.append("")
                tableView.reloadData()

                scrollFocus()
            }
        }
    }

}
