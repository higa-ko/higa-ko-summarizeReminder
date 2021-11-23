//
//  CategoryTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet private weak var alertImage: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var weekLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    // カテゴリービューに表示する用の関数
    func configureCategory(item: Item) {

        let weeks = ["月", "火", "水", "木", "金", "土", "日"]
        var weekValue = ""

        categoryLabel.text = item.category
        timeLabel.text = "\(item.hour)：\(item.minute)"

        for weekNumber in 0 ..< item.isWeekCheck.count where item.isWeekCheck[weekNumber] {
            weekValue += weeks[weekNumber] + " "
        }
        weekLabel.text = weekValue

        if item.isNoticeCheck {
            alertImage.image = UIImage(systemName: "flag")
            timeLabel.alpha = 1
            weekLabel.alpha = 1
        } else {
            alertImage.image = UIImage(systemName: "flag.slash")
            timeLabel.alpha = 0.5
            weekLabel.alpha = 0.5
        }
        numberLabel.text = String(item.task.count)
    }

}
