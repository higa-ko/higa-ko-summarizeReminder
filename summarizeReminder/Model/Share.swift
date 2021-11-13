//
//  Struct.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

struct Item {
    var category: String
    var task: [String]
    var isTaskCheck: [Bool]
    var isNoticeCheck: Bool
    var isWeekCheck: [Bool]
    var hour: Int
    var minute: Int
}

struct ProcessArray {

    // 新規カテゴリーを配列へ追加
    func addCategory(item: Item) {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 新規追加のパターン以外を弾く
        guard item.category != "" else { return } // カテゴリー名が記載されてない場合処理を終了

        // アイテム配列へのカテゴリー追加
        appDelegate.itemArray.append(item)
    }

    // 既存カテゴリーのカテゴリーを編集
    func editCategory(item: Item, categoryIndex: Int) {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 新規追加のパターン以外を弾く
        guard item.category != "" else { return } // カテゴリー名が記載されてない場合処理を終了

        // アイテム配列へのカテゴリー追加
        appDelegate.itemArray[categoryIndex] = item
    }

    // テスト用のデータを配列に入れる
    func settingArray() {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        appDelegate.itemArray = [
            Item(category: "今日やること",
                 task: ["腕立て", "腹筋", "スクワット"],
                 isTaskCheck: [true, true, true],
                 isNoticeCheck: true,
                 isWeekCheck: [true, true, false, false, false, false, false],
                 hour: 0,
                 minute: 0),

            Item(category: "買い物",
                 task: ["肉", "魚", "野菜", "米", "塩"],
                 isTaskCheck: [true, true, true, true, true],
                 isNoticeCheck: true,
                 isWeekCheck: [false, false, false, false, false, false, false],
                 hour: 10,
                 minute: 10),

            Item(category: "明日やること",
                 task: [],
                 isTaskCheck: [],
                 isNoticeCheck: false,
                 isWeekCheck: [false, false, false, false, false, false, false],
                 hour: 10,
                 minute: 20),

            Item(category: "テスト",
                 task: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"],
                 isTaskCheck: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
                 isNoticeCheck: false,
                 isWeekCheck: [false, false, false, false, false, false, false],
                 hour: 22,
                 minute: 30)
        ]
    }
}

struct Buttonformat {
    // ボタンの書式を統一するための関数
    func underButtonformat(button: UIButton!) {
        // ボタンのイメージのサイズを変更
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill

        button.layer.borderWidth = 0.1   // 罫線の太さ
        button.layer.cornerRadius = button.bounds.width / 2   // ボタンを丸く(高さに対して半分)
    }
}
