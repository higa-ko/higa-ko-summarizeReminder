//
//  CategoryTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

protocol CategoryButtonDelegate: AnyObject {
    func changeButton(cell: CategoryTableViewCell)
 }

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var bellButton: UIButton!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    // デリゲートの設定
    weak var categoryButtonDelegate: CategoryButtonDelegate?

    // カテゴリービューに表示する用の関数
    func configureCategory(item: Item) {

        let weeks = ["月", "火", "水", "木", "金", "土", "日"]
        var weekValue = ""
        let time = TimeInterval(item.hour * 3600 + item.minute * 60) // 時と分を秒に変換して足す
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]

        categoryLabel.text = item.category
        timeLabel.text = time == 0 ? "0:00" : formatter.string(from: time)

        for weekNumber in 0 ..< item.isWeekCheck.count where item.isWeekCheck[weekNumber] {
            weekValue += weeks[weekNumber] + " "
        }

        if weekValue == "" {
            weekLabel.text = "未設定"
        } else {
            weekLabel.text = weekValue
        }

        if item.isNoticeCheck {
            bellButton.setImage(UIImage(systemName: "bell"), for: .normal)
            timeLabel.alpha = 1
            weekLabel.alpha = 1
        } else {
            bellButton.setImage(UIImage(systemName: "bell.slash"), for: .normal)
            timeLabel.alpha = 0.5
            weekLabel.alpha = 0.5
        }

        // ボタンのイメージのサイズを変更
        bellButton.imageView?.contentMode = .scaleAspectFit
        bellButton.contentHorizontalAlignment = .fill
        bellButton.contentVerticalAlignment = .fill

        numberLabel.text = String(item.task.count)
    }

    @IBAction func changeButton(_ sender: UIButton) {
        categoryButtonDelegate?.changeButton(cell: self)
    }
}
