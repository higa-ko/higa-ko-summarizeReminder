//
//  TaskTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/31.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var displayTaskImage: UIImageView!
    @IBOutlet weak var displayTaskLable: UILabel!

    @IBOutlet weak var inputTaskImage: UIImageView!
    @IBOutlet weak var inputTaskTextField: UITextField!

    func configureDisplayTask(text: NSMutableAttributedString, taskCheck: Bool) {
        // タスクの選択状態を確認して処理を分岐
        if taskCheck {
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

    func configureInputTask(text: String) {
        inputTaskTextField.borderStyle = .none
        inputTaskTextField.text = text
    }
}
