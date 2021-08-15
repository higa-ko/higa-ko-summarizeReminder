//
//  CategoryTableViewCell.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var alertLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    func configure(item: Item) {
        categoryLabel.text = item.category
        alertLabel.text = item.alert
        numberLabel.text = item.number
    }
    
    //あとで調べる
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //あとで調べる
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
