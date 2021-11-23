//
//  InputTableViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/10/26.
//

import UIKit

enum InputMode {
    case add
    case edit
}

class InputTableViewController: UITableViewController {

    @IBOutlet private weak var newCategoryCheckSwitch: UISwitch!
    @IBOutlet private weak var categoryCell: UITableViewCell!
    @IBOutlet private weak var categoryChangeTextField: UITextField!
    @IBOutlet private weak var categoryChoiceLabel: UILabel!
    @IBOutlet private weak var noticeCheckSwitch: UISwitch!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var pushLabel: UILabel!
    @IBOutlet private weak var timePickerView: UIPickerView!
    @IBOutlet private weak var repeatCell: UITableViewCell!
    @IBOutlet private weak var repeatLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var taskCell: UITableViewCell!
    @IBOutlet private weak var taskLabel: UILabel!
    @IBOutlet private weak var taskNumberLabel: UILabel!
    @IBOutlet private weak var deleteButton: UIButton!

    var inputMode: InputMode = .add

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

    private let weeks = ["月", "火", "水", "木", "金", "土", "日"]

    private let hours = [Int](0...23)
    private let minutes = [Int](0...59)

    private let magnification = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        timePickerView.dataSource = self
        timePickerView.delegate = self

        switch inputMode {
        case .add:
            setUpCell(item: addItem, inputMode: inputMode)
        case .edit:
            setUpCell(item: editItem, inputMode: inputMode)
        }

        deleteButton.layer.borderWidth = 0.5
        deleteButton.layer.cornerRadius = 10 // 角を丸く

        print("いんぽーとビュー起動")

    }

    // Input画面に戻ってきた時の処理（初回表示も含む）
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("インポートビューに戻ってきた")

        categoryChangeTextField.becomeFirstResponder() // テキストフィールドにフォーカス

        switch inputMode {
        case .add:
            setUpCell(item: addItem, inputMode: inputMode)
        case .edit:
            setUpCell(item: editItem, inputMode: inputMode)
        }
    }

    @IBAction func newCategoryActionSwitch(_ sender: UISwitch) {
        if newCategoryCheckSwitch.isOn {
            inputMode = .add
            setUpCell(item: addItem, inputMode: inputMode)
        } else {
            inputMode = .edit
            setUpCell(item: editItem, inputMode: inputMode)
        }
    }

    @IBAction func changedCategoryTextField(_ sender: UITextField) {
        guard let category = categoryChangeTextField.text else { return }
        switch inputMode {
        case .add:
            addItem.category = category
        case .edit:
            editItem?.category = category
        }
    }

    @IBAction func noticeActionSwitch(_ sender: UISwitch) {
        switch inputMode {
        case .add:
            addItem.isNoticeCheck = noticeCheckSwitch.isOn
        case .edit:
            editItem?.isNoticeCheck = noticeCheckSwitch.isOn
        }

        if noticeCheckSwitch.isOn {
            timePickerView.alpha = 1
            timeLabel.alpha = 1
            repeatLabel.alpha = 1
            weekLabel.alpha = 1
        } else {
            timePickerView.alpha = 0.5
            timeLabel.alpha = 0.5
            repeatLabel.alpha = 0.5
            weekLabel.alpha = 0.5
        }
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

    @IBAction func deleteActionButton(_ sender: UIButton) {
        // アラート作成
        guard let category = editItem?.category else { return }
        guard let categoryIndex = categoryIndex else { return }
        let alert = UIAlertController(title: "カテゴリーを削除",
                                      message: "\"\(category)\"を削除しますか？",
                                      preferredStyle: .alert)

        // ボタンの作成、追加
        let deleteButton = UIAlertAction(title: "削除", style: .destructive) { _ in
            ProcessArray().removeCategory(categoryIndex: categoryIndex)
            self.editItem = nil
            self.categoryIndex = nil
            self.setUpCell(item: self.editItem, inputMode: self.inputMode)
        }
        alert.addAction(deleteButton)

        let cancelButton = UIAlertAction(title: "キャンセル", style: .cancel)
        alert.addAction(cancelButton)

        // アラートの表示
        present(alert, animated: true, completion: nil)
    }

    // アイテムの情報をテーブルビューへ反映
    private func setUpCell(item: Item?, inputMode: InputMode) {
        // 未設定の場合デフォルトの値を入れる
        let setItem = item ?? Item(category: "",
                                   task: [],
                                   isTaskCheck: [],
                                   isNoticeCheck: false,
                                   isWeekCheck: [false, false, false, false, false, false, false],
                                   hour: 0,
                                   minute: 0)

        var weekValue = ""

        // セルのアクセサリーの有無、削除ボタンの選択状態の有無
        switch inputMode {
        case .add:
            newCategoryCheckSwitch.isOn = true
            categoryCell.accessoryType = .none
            deleteButton.isEnabled = false
            deleteButton.alpha = 0.5
        case .edit:
            newCategoryCheckSwitch.isOn = false
            categoryCell.accessoryType = .disclosureIndicator

            if item == nil {
                deleteButton.isEnabled = false
                deleteButton.alpha = 0.5
            } else {
                deleteButton.isEnabled = true
                deleteButton.alpha = 1
            }
        }

        // 未設定かどうかで処理を変える部分
        if item == nil {
            categoryChoiceLabel.text = "未選択"
            noticeCheckSwitch.isEnabled = false
            timePickerView.isUserInteractionEnabled = false
            repeatCell.accessoryType = .none
            taskCell.accessoryType = .none
            pushLabel.alpha = 0.5
            timePickerView.alpha = 0.5
            timeLabel.alpha = 0.5
            repeatLabel.alpha = 0.5
            weekLabel.alpha = 0.5
            taskLabel.alpha = 0.5
            taskNumberLabel.alpha = 0.5
        } else {
            categoryChoiceLabel.text = ""
            noticeCheckSwitch.isEnabled = true
            timePickerView.isUserInteractionEnabled = true
            repeatCell.accessoryType = .disclosureIndicator
            taskCell.accessoryType = .disclosureIndicator
            pushLabel.alpha = 1
            timePickerView.alpha = 1
            timeLabel.alpha = 1
            repeatLabel.alpha = 1
            weekLabel.alpha = 1
            taskLabel.alpha = 1
            taskNumberLabel.alpha = 1
        }

        // カテゴリー名
        categoryChangeTextField.text = setItem.category

        // プッシュ通知
        noticeCheckSwitch.isOn = setItem.isNoticeCheck

        // プッシュ通知のステータスに合わせて設定を変更
        if setItem.isNoticeCheck {
            timePickerView.alpha = 1
            timeLabel.alpha = 1
            repeatLabel.alpha = 1
            weekLabel.alpha = 1
        } else {
            timePickerView.alpha = 0.5
            timeLabel.alpha = 0.5
            repeatLabel.alpha = 0.5
            weekLabel.alpha = 0.5
        }

        // 時間
        timePickerView.selectRow(setItem.hour + hours.count * magnification / 2, inComponent: 0, animated: false)
        timePickerView.selectRow(setItem.minute + minutes.count * magnification / 2, inComponent: 1, animated: false)

        // 繰り返し
        // isWeekCheck の内容に合わせて日付を表示　どこにもチェックがない場合は"未選択"で表示
        for weekNumber in 0 ..< setItem.isWeekCheck.count where setItem.isWeekCheck[weekNumber] {
            weekValue += weeks[weekNumber] + " "
        }
        if weekValue == "" {
            weekValue = "未選択"
        }
        weekLabel.text = weekValue

        // タスク
        taskNumberLabel.text = String(setItem.task.count)

    }

    private func changeAccessoryType(isStatus: Bool) {
        if isStatus {
            repeatCell.accessoryType = .disclosureIndicator
            taskCell.accessoryType = .disclosureIndicator
        } else {
            repeatCell.accessoryType = .none
            taskCell.accessoryType = .none
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    // セルタップ処理
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        switch indexPath.row {
        case 1:
            detailInputMode = .categorySelect
            performSegue(withIdentifier: K.SegueIdentifier.InputToSelect, sender: nil) // 詳細設定ビューへ移動
        case 4:
            detailInputMode = .repeatSelect
            performSegue(withIdentifier: K.SegueIdentifier.InputToSelect, sender: nil) // 詳細設定ビューへ移動
        case 5:
            detailInputMode = .repeatSelect
            performSegue(withIdentifier: K.SegueIdentifier.InputToTask, sender: nil) // タスクビューへ移動
        default:
            detailInputMode = .none
            print("指定外のindexPathが指定された")
        }
    }

    // セルが選択されそうな時の処理
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {

        switch indexPath.row {
        case 1:
            switch inputMode {
            case .add:
                return nil

            case .edit:
                return indexPath
            }

        case 4, 5:
            switch inputMode {
            case .add:
                changeAccessoryType(isStatus: true)
                return indexPath

            case .edit:
                if editItem == nil {
                    changeAccessoryType(isStatus: false)
                    return nil
                } else {
                    changeAccessoryType(isStatus: true)
                    return indexPath
                }
            }

        default:
            return nil
            }
        }

    }

    // MARK: - UIPickerViewDataSource, UIPickerViewDelegate
    extension InputTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
        // 表示列数
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }

        // 列ごとの行数
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            switch component {
            case 0:
                return hours.count * magnification
            case 1:
                return minutes.count * magnification
            default:
                print("存在しない列が指定されている(行数)")
                return 0
            }
        }

        // 列ごとの表示内容
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            switch component {
            case 0:
                return String(hours[row % hours.count])
            case 1:
                return String(minutes[row % minutes.count])
            default:
                print("存在しない列が指定されている(表示内容)")
                return String(hours[row])
            }
        }

        // UIPickerViewのRowが選択された時の挙動
        func pickerView(_ pickerView: UIPickerView,
                        didSelectRow row: Int,
                        inComponent component: Int) {

            switch component {
            case 0:
                let hour = hours[row % hours.count]
                self.timePickerView.selectRow(hour + hours.count * magnification / 2, inComponent: 0, animated: false)

                switch inputMode {
                case .add:
                    addItem.hour = hour
                case .edit:
                    editItem?.hour = hour
                }

            case 1:
                let minute = minutes[row % minutes.count]
                self.timePickerView.selectRow(minute + minutes.count * magnification / 2, inComponent: 1, animated: false)

                switch inputMode {
                case .add:
                    addItem.minute = minute
                case .edit:
                    editItem?.minute = minute
                }

            default:
                print("存在しない列が指定されている(選択された時の挙動)")
            }
        }
    }
