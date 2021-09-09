//
//  TaskTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/31.
//

import UIKit

protocol TaskTextFieldDelegate: AnyObject {
    func changedTaskTextField()
 }

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var displayTaskImage: UIImageView!
    @IBOutlet weak var displayTaskLable: UILabel!

    @IBOutlet weak var inputTaskImage: UIImageView!
    @IBOutlet weak var inputTaskTextField: UITextField!

    // デリゲートの設定
    weak var taskTextFieldDelegate: TaskTextFieldDelegate?

    // タスクビューのラベルに表示
    func configureDisplayTask(text: NSMutableAttributedString, isTaskCheck: Bool) {
        // タスクの選択状態を確認して処理を分岐
        if isTaskCheck {
            // タスクに訂正線を消す
            text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, text.length))
            displayTaskLable.attributedText = text
            displayTaskImage.image =  UIImage(systemName: "circle")
        } else {
            // タスクに訂正線を入れる
            text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, text.length))
            displayTaskLable.attributedText = text
            displayTaskImage.image =  UIImage(systemName: "largecircle.fill.circle")
        }
    }

    // タスクビューのテキストフィールドに表示
    func configureInputTask(text: String) {
        inputTaskTextField.borderStyle = .none // テキストフィールドの枠線を消す
        inputTaskTextField.text = text
    }

    @IBAction func changedTaskTextField(_ sender: UITextField) {
        taskTextFieldDelegate?.changedTaskTextField() // テキストフィールドを更新したらテーブルビューを更新する
    }

    func taskText() -> String {
        let text = inputTaskTextField.text
        return text!
    }

}
