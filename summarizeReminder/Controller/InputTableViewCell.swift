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
    @IBOutlet private weak var categoryInputTextField: UITextField!

    // プッシュ通知確認セル
    @IBOutlet private weak var noticeCheckSwitch: UISwitch!

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // デリゲートの設定
    weak var cellDegate: CustomCellDelegate?

    // 新規カテゴリー確認セル
    @IBAction func newCategoryActionSwitch(_ sender: UISwitch) {
        appDelegate!.newCategoryCheck = newCategoryCheckSwitch.isOn
        cellDegate?.newCategoryActionSwitch()
    }

    // プッシュ通知確認セル
    @IBAction func noticeActionSwitch(_ sender: UISwitch) {
        appDelegate!.noticeCheck = noticeCheckSwitch.isOn
        cellDegate?.noticeActionSwitch()
    }
}
