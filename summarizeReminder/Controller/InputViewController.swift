//
//  InputViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

enum InputMode {
    case add
    case edit
}

class InputViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var inputMode: InputMode = .add

    private var isNoticeCheck = false

    private var detailInputMode: DetailInputMode?

    private(set) var addItem: Item = Item(category: "", task: [], isTaskCheck: [], isAlert: false)
    private(set) var editItem: Item?

    private var categoryIndex: Int?

    // 表示するセル(初期値はaddモード)
    private var identifierArray = [
        K.CellIdentifier.NewCategoryCheckCell,
        K.CellIdentifier.CategoryInputCell,
        K.CellIdentifier.NoticeCheckCell,
        K.CellIdentifier.BlankCell,
        K.CellIdentifier.BlankCell,
        K.CellIdentifier.TaskAddCell
    ]

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // インポートビュー表示時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()  // 空のセルの区切り線だけ消す。

        // セルの選択を有効
        self.tableView.allowsSelection = true

        print("いんぽーとビュー起動")
    }

    // Input画面に戻ってきた時の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }

    // 画面推移の時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier ?? "" {
        case K.SegueIdentifier.InputToSelect:
            guard let detailInputVC = segue.destination as? DetailInputViewController else { return }
            detailInputVC.detailInputMode = detailInputMode

        default:
            break
        }
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

        let identifier = identifierArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? InputTableViewCell
        cell?.cellDegate = self

        return cell!
    }

    // セルタップ処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        switch indexPath.row {
        case 1:
            detailInputMode = .categorySelect
        case 4:
            detailInputMode = .repeatSelect
        case 5:
            detailInputMode = .taskSelect
        default:
            detailInputMode = .none
            print("指定外のindexPathが指定された")
        }

        // 詳細設定のビューへ移動
        performSegue(withIdentifier: K.SegueIdentifier.InputToSelect, sender: nil)
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let isDisplayCheck = InputTableViewCell().selectCell(row: indexPath.row,
                                                             inputMode: inputMode,
                                                             isNoticeCheck: isNoticeCheck)
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
    func changedCategoryTextField(cell: InputTableViewCell) {

        guard let category = cell.categoryInputTextField.text else { return }
        addItem.category = category
    }

    func newCategoryActionSwitch(cell: InputTableViewCell) {

        if cell.newCategoryCheckSwitch.isOn {
            inputMode = .add

            // モードに合わせて表示するセルを変更
            identifierArray[1] = K.CellIdentifier.CategoryInputCell

        } else {
            inputMode = .edit

            // モードに合わせて表示するセルを変更
            identifierArray[1] = K.CellIdentifier.CategorySelectCell
        }

        tableView.reloadData()
    }

    func noticeActionSwitch(cell: InputTableViewCell) {

        isNoticeCheck = cell.noticeCheckSwitch.isOn

        // アラートを使用するかのチェック
        switch inputMode {
        case .add:
            addItem.isAlert = isNoticeCheck
        case .edit:
            editItem?.isAlert = isNoticeCheck
        }

        if isNoticeCheck {
            // switchの選択状態に合わせて表示するセルを選択
            identifierArray[3] = K.CellIdentifier.TimeSelectCell
            identifierArray[4] = K.CellIdentifier.RepeatSelectCell
        } else {
            // switchの選択状態に合わせて表示するセルを選択
            identifierArray[3] = K.CellIdentifier.BlankCell
            identifierArray[4] = K.CellIdentifier.BlankCell
        }

        tableView.reloadData()
    }
}
