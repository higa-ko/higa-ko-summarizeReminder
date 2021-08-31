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

    @IBAction func addActionButton(_ sender: UIButton) {
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate!.itemArray[appDelegate!.categoryIndex!].task.count
    }

    // セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // appDelegateから参照しているカテゴリーのIndexを取り出す
        let index =  appDelegate!.categoryIndex!

        let identifier = K.CellIdentifier.DisplayTaskyCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let text =  NSMutableAttributedString(string: appDelegate!.itemArray[index].task[indexPath.row])

        // タスクの選択状態を確認して処理を分岐
        if appDelegate!.itemArray[index].taskCheck[indexPath.row] {
            // タスクに訂正線を消す
            text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, text.length))
            cell.textLabel?.attributedText = text
            cell.imageView?.image = UIImage(systemName: "circle")
        } else {
            // タスクに訂正線を入れる
            text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, text.length))
            cell.textLabel?.attributedText = text
            cell.imageView?.image = UIImage(systemName: "largecircle.fill.circle")
        }
        return cell
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
