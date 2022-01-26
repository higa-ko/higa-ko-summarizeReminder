//
//  Struct.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/15.
//

import UIKit

struct Item: Codable {
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 新規追加のパターン以外を弾く
        guard item.category != "" else { return } // カテゴリー名が記載されてない場合処理を終了

        // アイテム配列へのカテゴリー追加
        appDelegate.itemArray.append(item)

        // アイテム配列の保存
        savingArray()

        // プッシュ通知の設定
        ProcessPush().goPush()
    }

    // 既存カテゴリーのカテゴリーを編集
    func editArray(item: Item, categoryIndex: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // 新規追加のパターン以外を弾く
        guard item.category != "" else { return } // カテゴリー名が記載されてない場合処理を終了

        // アイテム配列へのカテゴリー追加
        appDelegate.itemArray[categoryIndex] = item

        // アイテム配列の保存
        savingArray()

        // プッシュ通知の設定
        ProcessPush().goPush()
    }

    // 既存カテゴリーの削除
    func removeCategory(categoryIndex: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        appDelegate.itemArray.remove(at: categoryIndex)

        // アイテム配列の保存
        savingArray()

        // プッシュ通知の設定
        ProcessPush().goPush()
    }

    // 保存
    func savingArray() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // `JSONEncoder` で `Data` 型へエンコードし、UserDefaultsに追加する
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(appDelegate.itemArray) else { return }

        UserDefaults.standard.set(data, forKey: K.SavingKey.ItemArrayKey)
    }

    // 呼び出し
    func loadingArray() {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // `JSONDecoder` で `Data` 型を自作した構造体へデコードする
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: K.SavingKey.ItemArrayKey),
              let itemArray = try? jsonDecoder.decode([Item].self, from: data) else {
                  // 失敗した時の処理を入れる
                  settingArray()
                  return
              }

        appDelegate.itemArray = itemArray
    }

    // 初回表示用のデータを配列に入れる
    func settingArray() {
        // AppDelegateの呼び出し
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        appDelegate.itemArray = []
    }
}

struct ProcessPush {

    // DateComponents()のweekdayに使用
    let sunday = 1 // 日曜日
    let monday = 2 // 月曜日
    let tuesday = 3 // 火曜日
    let wednesday = 4 // 水曜日
    let thursday = 5 // 木曜日
    let friday = 6 // 金曜日
    let saturday = 7 // 土曜日

    // ローカル通知の許可等
    func goPush() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            // もし通知が許可されているなら
            if settings.authorizationStatus == .authorized {
                // 通知
                setPush()

                // もし通知が許可されてないなら
            } else {
                print("もし通知が許可されていないのであれば")

                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.sound, .badge, .alert], completionHandler: { (granted, error) in

                        if let error = error {
                            print(error)
                        } else if granted {
                            setPush()
                        }
                    })
            }
        }
    }

    func setPush() {

        DispatchQueue.main.async(execute: {
            // AppDelegateの呼び出し
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let itemArray = appDelegate.itemArray

            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound.default

            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removeAllPendingNotificationRequests() // 通知設定の削除

            var dateComponentsDay = DateComponents()

            // アイテム配列分確認 // 通知が必要なアイテムか確認
            for itemIndex in 0..<itemArray.count
            where itemArray[itemIndex].isNoticeCheck {

                var task = ""
                // 表示内容の作成
                content.title = itemArray[itemIndex].category

                for taskIndex in 0..<itemArray[itemIndex].task.count
                where itemArray[itemIndex].isTaskCheck[taskIndex] {
                    if task != "" {
                        task += "\n"
                    }
                    task += itemArray[itemIndex].task[taskIndex]
                }

                content.body = task
                content.sound = UNNotificationSound.default

                // 表示時間の設定
                dateComponentsDay.hour = itemArray[itemIndex].hour
                dateComponentsDay.minute = itemArray[itemIndex].minute

                // isWeekCheckの配列の中に曜日の設定があるか確認
                if itemArray[itemIndex].isWeekCheck.contains(true) {
                    // 曜日の設定がある場合
                    for weeyIndex in 0..<itemArray[itemIndex].isWeekCheck.count
                    where itemArray[itemIndex].isWeekCheck[weeyIndex] {
                        switch weeyIndex {
                        case 0: dateComponentsDay.weekday = monday
                        case 1: dateComponentsDay.weekday = tuesday
                        case 2: dateComponentsDay.weekday = wednesday
                        case 3: dateComponentsDay.weekday = thursday
                        case 4: dateComponentsDay.weekday = friday
                        case 5: dateComponentsDay.weekday = saturday
                        case 6: dateComponentsDay.weekday = sunday
                        default: break
                        }

                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay,
                                                                    repeats: true) // トリガーを生成

                        let identifier = String(itemIndex) + "-" + String(weeyIndex) // identifierを生成
                        let request = UNNotificationRequest(identifier: identifier,
                                                            content: content,
                                                            trigger: trigger) // 通知データを作成

                        // 通知予約
                        notificationCenter.add(request) { (error) in
                            if error != nil {
                                print(error.debugDescription)
                            }
                        }
                    }
                } else {
                    // 曜日設定がない場合の処理 ★初回実装見送り
                }
            }

            // 登録されている通知確認（テスト用）
//            UNUserNotificationCenter.current().getPendingNotificationRequests {
//                print("Pending requests :", $0)
//            }
        })
    }
}

struct Buttonformat {
    // ボタンの書式を統一するための関数
    func underButtonformat(button: UIButton!) {
        // ボタンのイメージのサイズを変更
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill

        button.layer.borderWidth = 0.5   // 罫線の太さ
        button.layer.borderColor = UIColor.gray.cgColor // 枠線をグレー
        button.layer.cornerRadius = button.bounds.width / 2   // ボタンを丸く(高さに対して半分)
    }
}
