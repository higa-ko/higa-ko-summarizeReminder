//
//  InputTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    func newCategoryActionSwitch(cell: InputTableViewCell)
    func noticeActionSwitch(cell: InputTableViewCell)
    func changedCategoryTextField(cell: InputTableViewCell)
}

class InputTableViewCell: UITableViewCell {

    // 新規カテゴリー確認セル
    @IBOutlet private(set) weak var newCategoryCheckSwitch: UISwitch!

    // 新規カテゴリー入力セル
    @IBOutlet private(set) weak var categoryInputTextField: UITextField!

    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var categoryChoiceLabel: UILabel!

    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var taskNumberLabel: UILabel!

    // プッシュ通知確認セル
    @IBOutlet private(set) weak var noticeCheckSwitch: UISwitch!

    @IBOutlet weak var timePickerView: UIPickerView!

    // デリゲートの設定
    weak var cellDegate: CustomCellDelegate?

    // 新規カテゴリー名が入力された時
    @IBAction func changedCategoryTextField(_ sender: UITextField) {
        cellDegate?.changedCategoryTextField(cell: self)
    }

    // 新規カテゴリー確認セル
    @IBAction func newCategoryActionSwitch(_ sender: UISwitch) {
        cellDegate?.newCategoryActionSwitch(cell: self)
    }

    // プッシュ通知確認セル
    @IBAction func noticeActionSwitch(_ sender: UISwitch) {
        cellDegate?.noticeActionSwitch(cell: self)
    }

    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var repeatLabel: UILabel!

    @IBOutlet weak var weekLabel: UILabel!

    let hours: [Int] = Array(0...23)

    let minutes: [Int] = Array(0...59)

    private let max = 100

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    func selectNoticeCheckSwitch(isNoticeCheck: Bool) {
        noticeCheckSwitch.isOn = isNoticeCheck
    }

    // セルのidentifierを確認してセルが選択可能にするかを返す
    func selectCell(row: Int, inputMode: InputMode, isNoticeCheck: Bool?) -> Bool {
        // 行数によってセルを選択できるか確認
        switch row {

        case 0, 2, 3:
            return false

        case 1:
            switch inputMode {
            case .add:
                return false
            case .edit:
                return true
            }

        case 4:
            if isNoticeCheck ?? false {
                return true
            } else {
                return false
            }

            // 既存変更のカテゴリー未設定の場合のみセルを選択できないようにする
        case 5:
            if isNoticeCheck == nil {
                return false
            } else {
                return true
            }

        default:
            print("指定のセルが存在しない")
            return false
        }
    }

    // ピッカービューの初期値を設定
    func defaultSelectRow(hour: Int, minute: Int) {
        timePickerView.selectRow(hour + hours.count * max / 2, inComponent: 0, animated: false)
        timePickerView.selectRow(minute + minutes.count * max / 2, inComponent: 1, animated: false)
    }

}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension InputTableViewCell: UIPickerViewDataSource, UIPickerViewDelegate {
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

//                switch component {
//                case 0:
//                    time.hour = hours[row % hours.count]
//                    self.pickerView.selectRow(time.hour + hours.count * max / 2, inComponent: 0, animated: false)
//
//                case 1:
//                    time.minute = minutes[row % minutes.count]
//                    self.pickerView.selectRow(time.minute + minutes.count * max / 2, inComponent: 1, animated: false)
//
//                default:
//                    print("存在しない列が指定されている(選択された時の挙動)")
//                }
    }

}
