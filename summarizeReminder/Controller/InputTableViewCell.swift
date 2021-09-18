//
//  InputTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

protocol CustomCellDelegate: AnyObject {
    func newCategoryActionSwitch()
    func noticeActionSwitch()
}

class InputTableViewCell: UITableViewCell {

    // 新規カテゴリー確認セル
    @IBOutlet private weak var newCategoryCheckSwitch: UISwitch!

    // 新規カテゴリー入力セル
    @IBOutlet /*private*/ weak var categoryInputTextField: UITextField!

    // プッシュ通知確認セル
    @IBOutlet private weak var noticeCheckSwitch: UISwitch!

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // デリゲートの設定
    weak var cellDegate: CustomCellDelegate?

    // 新規カテゴリー名が入力された時
    @IBAction func changedCategoryTextField(_ sender: UITextField) {
        guard let newCategory = categoryInputTextField.text else { return }
        appDelegate?.addItem.category = newCategory
    }

    // 新規カテゴリー確認セル
    @IBAction func newCategoryActionSwitch(_ sender: UISwitch) {
        appDelegate!.isNewCategoryCheck = newCategoryCheckSwitch.isOn
        cellDegate?.newCategoryActionSwitch()
    }

    // プッシュ通知確認セル
    @IBAction func noticeActionSwitch(_ sender: UISwitch) {
        appDelegate!.isNoticeCheck = noticeCheckSwitch.isOn
        cellDegate?.noticeActionSwitch()
    }

    // セルのidentifierを確認してセルが選択可能にするかを返す
    func selectCell(row: Int) -> Bool {
        // 行数によってセルを選択できるか確認
        switch row {

        case 0:
            return false

        case 1:
            if appDelegate!.isNewCategoryCheck {
                return false
            } else {
                return true
            }

        case 2:
            return false

        case 3:
            if appDelegate!.isNoticeCheck {
                return false
            } else {
                return false
            }

        case 4:
            if appDelegate!.isNoticeCheck {
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
