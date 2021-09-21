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

    // 新規カテゴリーを配列へ追加
    func addCategory(item: Item) {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 新規追加のパターン以外を弾く
        guard item.category != "" else { return } // カテゴリー名が記載されてない場合処理を終了

        // アイテム配列へのカテゴリー追加
        appDelegate.itemArray.append(item)
    }

    // タスクにチェックがついている場合配列の要素から削除
    func deleteTaskCheck(categoryIndex: Int) {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        guard appDelegate.itemArray[categoryIndex].task != [] else { return } // タスクが空の場合は処理をスキップ

        let max = appDelegate.itemArray[categoryIndex].task.count // タスクの項目数を取得

        // swiftlint:disable identifier_name
        for i in 0 ..< max {
            // swiftlint:enable identifier_name
            let taskCheck = appDelegate.itemArray[categoryIndex].isTaskCheck[(max - 1) - i]

            if taskCheck {
            } else {
                appDelegate.itemArray[categoryIndex].task.remove(at: (max - 1) - i)
                appDelegate.itemArray[categoryIndex].isTaskCheck.remove(at: (max - 1) - i)
            }
        }
    }

    // タスクが空白になっている場合配列の要素から削除
    func deleteTaskBlank(categoryIndex: Int) {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let max = appDelegate.itemArray[categoryIndex].task.count // タスクの項目数を取得

        // swiftlint:disable identifier_name
        // タスクの配列の後ろからタスクが空白になっているものを削除
        for i in 0 ..< max where appDelegate.itemArray[categoryIndex].task[(max - 1) - i] == ""{
        // swiftlint:enable identifier_name

            appDelegate.itemArray[categoryIndex].task.remove(at: (max - 1) - i)
            appDelegate.itemArray[categoryIndex].isTaskCheck.remove(at: (max - 1) - i)
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
