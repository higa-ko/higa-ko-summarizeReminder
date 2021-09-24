//
//  CategoryTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var alertImage: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!

    // カテゴリービューに表示する用の関数
    func configureCategory(item: Item) {
        categoryLabel.text = item.category

        if item.isNoticeCheck {
            alertLabel.text = "アラートあり"
            alertImage.image = UIImage(systemName: "bell")
        } else {
            alertLabel.text = "アラートなし"
            alertImage.image = UIImage(systemName: "bell.slash")
        }
        numberLabel.text = String(item.task.count)
    }

    // あとで調べる
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // あとで調べる
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
