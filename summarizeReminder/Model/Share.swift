//
//  Struct.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

struct Share {

    // ボタンの書式を統一するための関数
    func buttonOutlet(button: UIButton!) {
        // ボタンのイメージのサイズを変更
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill

        button.layer.borderWidth = 0.1   // 罫線の太さ
        button.layer.cornerRadius = button.bounds.width / 2   // ボタンを丸く(高さに対して半分)
    }
}
