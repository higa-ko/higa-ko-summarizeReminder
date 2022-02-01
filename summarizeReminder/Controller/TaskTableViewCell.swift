//
//  TaskTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/31.
//

import UIKit

protocol TaskTableViewCellDelegate: AnyObject {
    func endActionTextField()
    func changedTextField(cell: TaskTableViewCell)
 }

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak private var taskImage: UIImageView!
    @IBOutlet weak var taskTextField: UITextField!

    // デリゲートの設定
    weak var taskTableViewCellDelegate: TaskTableViewCellDelegate?

    // タスクビューのラベルに表示
    func configureDisplayTask(text: String, taskMode: TaskMode, isTaskCheck: Bool) {

        switch taskMode {
        case .check:

            let text = NSMutableAttributedString(string: text)

            taskTextField.isEnabled = false

            // タスクの選択状態を確認して処理を分岐
            if isTaskCheck {
                // タスクに訂正線を消す
                text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, text.length))
                taskImage.image =  UIImage(systemName: "circle")
            } else {
                // タスクに訂正線を入れる
                text.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, text.length))
                taskImage.image =  UIImage(systemName: "largecircle.fill.circle")
            }

            taskTextField.attributedText = text

        case .add:

            taskTextField.isEnabled = true
            taskTextField.text = text
            taskImage.image =  UIImage(systemName: "pencil")
        }

        taskTextField.borderStyle = .none // テキストフィールドの枠線を消す

    }

    // テキストフィールドを編集した時の処理
    @IBAction func changedTextField(_ sender: UITextField) {
        taskTableViewCellDelegate?.changedTextField(cell: self)
    }

    // テキストフィールドを改行した時の処理
    @IBAction func endActionTextField(_ sender: UITextField) {
        taskTableViewCellDelegate?.endActionTextField()
    }

    // テキストフィールド内の文字を返す
    func getTaskText() -> String {
        let text = taskTextField.text
        return text!
    }

}
