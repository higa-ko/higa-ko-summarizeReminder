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
    var isAlert: Bool
}

struct ProcessArray {
    func addCategory() {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 新規追加のパターン以外を弾く
        guard appDelegate.newCategoryCheck else { return } // 新規追加のスイッチがオフの場合処理を終了
        guard appDelegate.addItem.category != "" else { return } // カテゴリー名が記載されてない場合処理を終了

        // アイテム配列へのカテゴリー追加
        appDelegate.itemArray.append(appDelegate.addItem)

        // 追加用変数の初期化
        appDelegate.addItem = Item(category: "", task: [], isTaskCheck: [], isAlert: false)
    }

    func deleteTask() {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        guard let index = appDelegate.categoryIndex else { return } // カテゴリーが選択済か確認
        guard appDelegate.itemArray[index].task != [] else { return } // タスクが空の場合は処理をスキップ

        let max = appDelegate.itemArray[index].task.count // タスクの項目数を取得

        // swiftlint:disable identifier_name
        for i in 0 ..< max {
        // swiftlint:enable identifier_name
            let taskCheck = appDelegate.itemArray[index].isTaskCheck[(max - 1) - i]

            if taskCheck {
            } else {
                appDelegate.itemArray[index].task.remove(at: (max - 1) - i)
                appDelegate.itemArray[index].isTaskCheck.remove(at: (max - 1) - i)
            }
        }
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
