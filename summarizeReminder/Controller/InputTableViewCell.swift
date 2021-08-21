//
//  InputTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

class InputTableViewCell: UITableViewCell {
    
    //新規カテゴリー確認セル
    @IBOutlet private weak var newCategoryCheckSwitch: UISwitch!
    
    //新規カテゴリー入力セル
    @IBOutlet private weak var categoryInputTextField: UITextField!
    
    //プッシュ通知確認セル
    @IBOutlet private weak var noticeCheckSwitch: UISwitch!
    
    //AppDelegateの呼び出し
    private let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //新規カテゴリー確認セル
    @IBAction func newCategoryActionSwitch(_ sender: UISwitch) {
        delegate.newCategoryCheck = newCategoryCheckSwitch.isOn
        print(delegate.newCategoryCheck)
    }


    //プッシュ通知確認セル
    @IBAction func noticeActionSwitch(_ sender: UISwitch) {
        delegate.noticeCheck = noticeCheckSwitch.isOn
        print(delegate.noticeCheck)
    }

    
}
