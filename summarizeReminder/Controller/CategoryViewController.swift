//
//  ViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

// CategoryViewControllerの状態を管理
enum CategoryMode {
    case standard
    case edit
}

class CategoryViewController: UIViewController {

    @IBOutlet private weak var editBarButton: UIBarButtonItem!

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var underButton: UIButton!

    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    private var categoryMode: CategoryMode = .standard

    private var categoryIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 空のセルの区切り線だけ消す。
        tableView.tableFooterView = UIView()

        // ボタンの書式を変更
        Buttonformat().underButtonformat(button: underButton)

        // 保存しているアイテム配列の呼び出し
        ItemArrayProcessor().loadingArray()

        // 通知の許可
        PushProcessor().goPush()
    }

    // カテゴリー画面に戻ってきた時の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        categoryMode = .standard
        switchingMode(mode: categoryMode)

        tableView.reloadData()
    }

    // 画面推移の時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier ?? "" {
        case Constants.SegueIdentifier.CategoryToTask:
            guard let taskVC = segue.destination as? TaskViewController else { return }
            guard let categoryIndex = categoryIndex else { return }
            taskVC.beforeExistingItem = appDelegate?.itemArray[categoryIndex]
            taskVC.taskMode = .check
            taskVC.transitionSource = .categoryEdit(categoryIndex)

        case Constants.SegueIdentifier.CategoryToInput:
            if case .edit = categoryMode {
                guard let navigation = segue.destination as? UINavigationController else { return }
                guard let inputTVC = navigation.topViewController as? InputTableViewController else { return }
                guard let categoryIndex = categoryIndex else { return }
                inputTVC.editItem = appDelegate?.itemArray[categoryIndex]
                inputTVC.inputMode = .edit
                inputTVC.categoryIndex = categoryIndex
            }

        default:
            break
        }

    }

    // キャンセルしてカテゴリー画面へ戻ってくる
    @IBAction private func exitCancel(segue: UIStoryboardSegue) {
    }

    // 完了してカテゴリー画面へ戻ってくる
    @IBAction private func exitDone(segue: UIStoryboardSegue) {

        guard let inputTVC = segue.source as? InputTableViewController else { return }

        switch inputTVC.inputMode {
        case .add:
            let addItem = inputTVC.addItem

            ItemArrayProcessor().addCategory(item: addItem)
        case .edit:
            guard let editItem = inputTVC.editItem else { return }
            guard let categoryIndex = inputTVC.categoryIndex else { return }

            ItemArrayProcessor().editArray(item: editItem, categoryIndex: categoryIndex)
        }

        tableView.reloadData()
    }

    @IBAction func changeMode(_ sender: UIBarButtonItem) {

        if tableView.isEditing {
            categoryMode = .standard
        } else {
            categoryMode = .edit
        }
        switchingMode(mode: categoryMode)
    }

    @IBAction func shiftUnderButton(_ sender: UIButton) {
        // Inputビューへの推移
        performSegue(withIdentifier: Constants.SegueIdentifier.CategoryToInput, sender: nil)
    }

    private func switchingMode(mode: CategoryMode) {
        switch mode {
        case .standard:
            editBarButton.title = "編集"
            tableView.setEditing(false, animated: true)
            underButton.isEnabled = true
            underButton.alpha = 1
        case .edit:
            editBarButton.title = "完了"
            tableView.setEditing(true, animated: true)
            underButton.isEnabled = false
            underButton.alpha = 0.5
        }
    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate!.itemArray.count
    }

    // セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = Constants.CellIdentifier.CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CategoryTableViewCell
        let item = appDelegate!.itemArray[indexPath.row]

        cell?.configureCategory(item: item)
        cell?.categoryTableViewCellDelegate = self

        return cell!
    }

    // セルタップ処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除
        categoryIndex = indexPath.row

        switch categoryMode {
        case .standard:
            // タスクビューへの推移
            performSegue(withIdentifier: Constants.SegueIdentifier.CategoryToTask, sender: nil)
        case .edit:
            // Inputビューへの推移
            performSegue(withIdentifier: Constants.SegueIdentifier.CategoryToInput, sender: nil)
        }

    }

    // セルを削除(カテゴリー削除)
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            ItemArrayProcessor().removeCategory(categoryIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}

// MARK: - CategoryButtonDelegate
extension CategoryViewController: CategoryTableViewCellDelegate {
    func changeButton(cell: CategoryTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        switch categoryMode {
        case .standard:
            appDelegate!.itemArray[indexPath.row].isNoticeCheck.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        case .edit:
            break
        }
    }
}
