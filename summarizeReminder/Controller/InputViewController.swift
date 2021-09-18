//
//  InputViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

class InputViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // インポートビュー表示時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()  // 空のセルの区切り線だけ消す。

        // Switchの初期値を固定
        appDelegate?.isNewCategoryCheck = true
        appDelegate?.isNoticeCheck = false

        // セルの選択を有効
        self.tableView.allowsSelection = true

        print("いんぽーとビュー起動")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension InputViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 // 現時点のマックス行数を入れておく
    }

    // セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var identifier: String?

        // 行数によって表示するセルを設定
        switch indexPath.row {

        case 0:
            identifier = K.CellIdentifier.NewCategoryCheckCell

        case 1:
            if appDelegate!.isNewCategoryCheck {
                identifier = K.CellIdentifier.CategoryInputCell
            } else {
                identifier = K.CellIdentifier.CategorySelectCell
            }

        case 2:
            identifier = K.CellIdentifier.NoticeCheckCell

        case 3:
            if appDelegate!.isNoticeCheck {
                identifier = K.CellIdentifier.TimeSelectCell
            } else {
                identifier = K.CellIdentifier.BlankCell
            }

        case 4:
            if appDelegate!.isNoticeCheck {
                identifier = K.CellIdentifier.RepeatSelectCell
            } else {
                identifier = K.CellIdentifier.BlankCell
            }

        case 5:
            identifier = K.CellIdentifier.TaskAddCell

        default:
            print("エラー")
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath) as? InputTableViewCell
        cell!.cellDegate = self

        return cell!
    }

    // セルタップ処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        // 詳細設定のビューへ移動
        performSegue(withIdentifier: K.SegueIdentifier.InputToSelect, sender: nil)
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let isDisplayCheck = InputTableViewCell().selectCell(row: indexPath.row)
        // 表示されているセルに合わせて選択の可否を指定
        if isDisplayCheck {
            return indexPath // セルを選択可能に変更
        } else {
            return nil // セルを選択不可に変更
        }
    }

}

// MARK: - CustomCellDelegate
extension InputViewController: CustomCellDelegate {
    func newCategoryActionSwitch() {
        tableView.reloadData()
    }

    func noticeActionSwitch() {
        tableView.reloadData()
    }
}
