//
//  AppDelegate.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // swiftlint:disable line_length

    // ーーーーーーーーーー共通変数ーーーーーーーーーー

    // 配列を定義
    var itemArray: [Item] = [
        Item(category: "今日やること", task: ["腕立て", "腹筋", "スクワット"], isTaskCheck: [true, true, true], isAlert: true),
        Item(category: "買い物", task: ["肉", "魚", "野菜", "米", "塩"], isTaskCheck: [true, true, true, true, true], isAlert: true),
        Item(category: "明日やること", task: [], isTaskCheck: [], isAlert: false),
        Item(category: "テスト",
             task: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"],
             isTaskCheck: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
             isAlert: false)
    ]

    // ーーーーーーーーーー共通変数ーーーーーーーーーー

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
