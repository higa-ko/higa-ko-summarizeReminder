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
    @IBOutlet weak var categoryChoice: UILabel!

    // プッシュ通知確認セル
    @IBOutlet private(set) weak var noticeCheckSwitch: UISwitch!

    @IBOutlet weak var weekLabel: UILabel!

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

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

    func selectNoticeCheckSwitch(isNoticeCheck: Bool) {
        noticeCheckSwitch.isOn = isNoticeCheck
    }

    // セルのidentifierを確認してセルが選択可能にするかを返す
    func selectCell(row: Int, inputMode: InputMode, isNoticeCheck: Bool) -> Bool {
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
            if isNoticeCheck {
                return true
            } else {
                return false
            }

        case 5:
            return true

        default:
            print("指定のセルが存在しない")
            return false
        }
    }
}
