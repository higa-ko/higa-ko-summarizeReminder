//
//  AppDelegate.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //配列を定義
    var itemArray: [Item] = [
        Item(category: "今日やること", task: ["腕立て","腹筋"], taskCheck: [true, true] , alert: true),
        Item(category: "買い物", task: ["肉","魚","野菜"], taskCheck: [true, true, true], alert: true),
        Item(category: "明日やること", task: [], taskCheck: [], alert: false),
    ]

    //選んだカテゴリーの番号
    var categoryIndex: Int?

    //新規カテゴリーかどうかの確認
    var newCategoryCheck: Bool?

    //プッシュ通知が必要かどうかの確認
    var noticeCheck: Bool?

    

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

