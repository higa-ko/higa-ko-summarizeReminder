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

    @IBOutlet weak var newCategoryCheckSwitch: UISwitch!
    @IBOutlet weak var categoryChangeTextField: UITextField!
    @IBOutlet weak var categoryChoiceLabel: UILabel!
    @IBOutlet weak var noticeCheckSwitch: UISwitch!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!

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

    private let weeks = ["日", "月", "火", "水", "木", "金", "土"]

    let hours = [Int](0...23)
    let minutes = [Int](0...59)

    private let max = 100

    override func viewDidLoad() {
        super.viewDidLoad()

        timePickerView.dataSource = self
        timePickerView.delegate = self

        switch inputMode {
        case .add:
            setUpItem(item: addItem)
        case .edit:
            setUpItem(item: editItem)
        }

        print("いんぽーとビュー起動")

    }

    // Input画面に戻ってきた時の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("インポートビューに戻ってきた")

        switch inputMode {
        case .add:
            setUpItem(item: addItem)
        case .edit:
            setUpItem(item: editItem)
        }
    }

    @IBAction func newCategoryActionSwitch(_ sender: UISwitch) {
        if newCategoryCheckSwitch.isOn {
            inputMode = .add
            setUpItem(item: addItem)
        } else {
            inputMode = .edit
            setUpItem(item: editItem)
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

    // ピッカービューの初期値を設定
    private func defaultSelectRow(hour: Int, minute: Int) {
        timePickerView.selectRow(hour + hours.count * max / 2, inComponent: 0, animated: false)
        timePickerView.selectRow(minute + minutes.count * max / 2, inComponent: 1, animated: false)
    }

    // アイテムの情報をテーブルビューへ反映
    private func setUpItem(item: Item?) {
        // 未設定の場合デフォルトの値を入れる
        let setItem = item ?? Item(category: "",
                                   task: [],
                                   isTaskCheck: [],
                                   isNoticeCheck: false,
                                   isWeekCheck: [false, false, false, false, false, false, false],
                                   hour: 0,
                                   minute: 0)

        var weekValue = ""

        // 未設定かどうかで処理を変える部分
        if item == nil {
            categoryChoiceLabel.text = "未選択"
            timePickerView.isUserInteractionEnabled = false
        } else {
            categoryChoiceLabel.text = ""
            timePickerView.isUserInteractionEnabled = true
        }

        // カテゴリー名
        categoryChangeTextField.text = setItem.category

        // プッシュ通知
        noticeCheckSwitch.isOn = setItem.isNoticeCheck

        // 時間
        timePickerView.selectRow(setItem.hour + hours.count * max / 2, inComponent: 0, animated: false)
        timePickerView.selectRow(setItem.minute + minutes.count * max / 2, inComponent: 1, animated: false)

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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
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
            detailInputMode = .taskSelect
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
                return indexPath

            case .edit:
                if editItem == nil {
                    return nil
                } else {
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
                return hours.count * max
            case 1:
                return minutes.count * max
            default:
                print("存在しない列が指定されている(行数)")
                return hours.count
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
                self.timePickerView.selectRow(hour + hours.count * max / 2, inComponent: 0, animated: false)

                switch inputMode {
                case .add:
                    addItem.hour = hour
                case .edit:
                    editItem?.hour = hour
                }

            case 1:
                let minute = minutes[row % minutes.count]
                self.timePickerView.selectRow(minute + minutes.count * max / 2, inComponent: 1, animated: false)

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
