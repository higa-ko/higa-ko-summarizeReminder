//
//  InputViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

//enum InputMode {
//    case add
//    case edit
//}

class InputViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private(set) var inputMode: InputMode = .add

    private var detailInputMode: DetailInputMode?

    var addItem: Item = Item(category: "",
                             task: [],
                             isTaskCheck: [],
                             isNoticeCheck: false,
                             isWeekCheck: [false, false, false, false, false, false, false],
                             hour: 0,
                             minute: 0)

    var editItem: Item?

    var categoryIndex: Int?

    // 表示するセル(初期値はaddモード)
    private var identifierArray = [
        K.CellIdentifier.NewCategoryCheckCell,
        K.CellIdentifier.CategoryInputCell,
        K.CellIdentifier.NoticeCheckCell,
        K.CellIdentifier.TimeSelectCell,
        K.CellIdentifier.RepeatSelectCell,
        K.CellIdentifier.TaskAddCell
    ]

    private let weeks = ["日", "月", "火", "水", "木", "金", "土"]

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

        print("インポートビューに戻ってきた")

        tableView.reloadData()
    }

    // 画面推移の時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier ?? "" {
        case K.SegueIdentifier.InputToSelect:
            guard let detailInputVC = segue.destination as? DetailInputViewController else { return }
            detailInputVC.detailInputMode = detailInputMode
            detailInputVC.categoryIndex = categoryIndex

            switch inputMode {
            case .add:
                detailInputVC.weekArray.isWeekCheck = addItem.isWeekCheck
            case .edit:
                detailInputVC.weekArray.isWeekCheck = editItem?.isWeekCheck ??
                [false, false, false, false, false, false, false]
            }

        case K.SegueIdentifier.InputToTask:
            guard let taskVC = segue.destination as? TaskViewController else { return }

            switch inputMode {
            case .add:
                taskVC.taskMode = .add
                taskVC.beforeExistingItem = addItem
                taskVC.transitionSource = .inputAdd
            case .edit:
                guard let categoryIndex = categoryIndex else { return }
                taskVC.taskMode = .check
                taskVC.beforeExistingItem = editItem
                taskVC.transitionSource = .inputEdit(categoryIndex)
            }

        default:
            break
        }
    }

    // スイッチのステータスに合わせてidentifierを変更
    func changeNewCategoryIdentifier(isNewCategoryCheck: Bool) {

        if isNewCategoryCheck {
            identifierArray[1] = K.CellIdentifier.CategoryInputCell
        } else {
            identifierArray[1] = K.CellIdentifier.CategorySelectCell
        }
    }

    func xxx(hour: Int, minute: Int) {
        switch inputMode {
        case .add:
            addItem.hour = hour
            addItem.minute = minute
        case .edit:
            editItem?.hour = hour
            editItem?.minute = minute
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension InputViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return identifierArray.count
    }

    // セルに表示する内容
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = identifierArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? InputTableViewCell
        cell?.cellDegate = self

        let isNoticeCheck: Bool
        let isWeekCheck: [Bool]
        var weekValue = ""
        let isTaskAlphaCheck: Bool
        let taskNumber: Int
        let hour: Int
        let minute: Int

        // モードに合わせて配列から情報を取得
        switch inputMode {
        case .add:
            isNoticeCheck = addItem.isNoticeCheck
            isWeekCheck = addItem.isWeekCheck
            isTaskAlphaCheck = true
            taskNumber = addItem.task.count
            hour = addItem.hour
            minute = addItem.minute
        case .edit:
            isNoticeCheck = editItem?.isNoticeCheck ?? false
            isWeekCheck = editItem?.isWeekCheck ?? [false, false, false, false, false, false, false]
            isTaskAlphaCheck = editItem == nil ? false : true
            taskNumber = editItem?.task.count ?? 0
            hour = editItem?.hour ?? 0
            minute = editItem?.minute ?? 0
        }

        // 特定のセルのみ表示を変更
        switch identifier {
        case K.CellIdentifier.CategorySelectCell:
            if let categoryIndex = categoryIndex {
                cell?.categoryNameLabel.text = appDelegate?.itemArray[categoryIndex].category
                cell?.categoryChoiceLabel.text = ""
            } else {
                cell?.categoryNameLabel.text = "カテゴリーを選ぶ"
                cell?.categoryChoiceLabel.text = "未選択"
            }

        case K.CellIdentifier.NoticeCheckCell:
            cell?.noticeCheckSwitch.isOn = isNoticeCheck

        case K.CellIdentifier.TimeSelectCell:

            // ピッカービューの初期値を設定
            cell?.defaultSelectRow(hour: hour, minute: minute)

            if isNoticeCheck {
                cell?.timeLabel.alpha = 1
                cell?.timePickerView.alpha = 1
                cell?.timePickerView.isUserInteractionEnabled = true // 選択化
            } else {
                cell?.timeLabel.alpha = 0.5
                cell?.timePickerView.alpha = 0.5
                cell?.timePickerView.isUserInteractionEnabled = false // 選択不可
            }

        case K.CellIdentifier.RepeatSelectCell:
            // isWeekCheck の内容に合わせて日付を表示　どこにもチェックがない場合は"未選択"で表示
            for weekNumber in 0 ..< isWeekCheck.count where isWeekCheck[weekNumber] {
                weekValue += weeks[weekNumber] + " "
            }
            if weekValue == "" {
                weekValue = "未選択"
            }

            cell?.weekLabel.text = weekValue

            if isNoticeCheck {
                cell?.repeatLabel.alpha = 1
                cell?.weekLabel.alpha = 1
            } else {
                cell?.repeatLabel.alpha = 0.5
                cell?.weekLabel.alpha = 0.5
            }

        case K.CellIdentifier.TaskAddCell:
            cell?.taskNumberLabel.text = String(taskNumber)

            if isTaskAlphaCheck {
                cell?.taskLabel.alpha = 1
                cell?.taskNumberLabel.alpha = 1
            } else {
                cell?.taskLabel.alpha = 0.5
                cell?.taskNumberLabel.alpha = 0.5
            }

        default:
            break
        }
        return cell!
    }

    // セルタップ処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        switch indexPath.row {
        case 1:
            detailInputMode = .categorySelect
            performSegue(withIdentifier: K.SegueIdentifier.InputToSelect, sender: nil) // 詳細設定ビューへ移動
        case 4:
            detailInputMode = .repeatSelect
            performSegue(withIdentifier: K.SegueIdentifier.InputToSelect, sender: nil) // 詳細設定ビューへ移動
        case 5:
            detailInputMode = .taskSelect
            performSegue(withIdentifier: K.SegueIdentifier.InputToTask, sender: nil) // タスクビューへ移動
        default:
            detailInputMode = .none
            print("指定外のindexPathが指定された")
        }

    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let isNoticeCheck: Bool?
        switch inputMode {
        case .add:
            isNoticeCheck = addItem.isNoticeCheck
        case .edit:
            isNoticeCheck = editItem?.isNoticeCheck
        }

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

        let isNewCategoryCheck = cell.newCategoryCheckSwitch.isOn

        // スイッチのステータスに合わせてモードを変更
        if isNewCategoryCheck {
            inputMode = .add
        } else {
            inputMode = .edit
        }

        // スイッチのステータスに合わせてIdentifierを変更
        changeNewCategoryIdentifier(isNewCategoryCheck: isNewCategoryCheck)

        tableView.reloadData()
    }

    func noticeActionSwitch(cell: InputTableViewCell) {

        let isNoticeCheck = cell.noticeCheckSwitch.isOn

        // アラートの通知設定を変更
        switch inputMode {
        case .add:
            addItem.isNoticeCheck = isNoticeCheck
        case .edit:
            editItem?.isNoticeCheck = isNoticeCheck
        }

        tableView.reloadData()
    }
}
