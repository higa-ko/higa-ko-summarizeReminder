//
//  ViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit
import AppTrackingTransparency  // トラッキングの許可
import AdSupport    // トラッキングの許可

class CategoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    // 下にある+ボタン
    @IBOutlet private weak var underButton: UIButton!

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    private var categoryIndex: Int?

    // 画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()  // 空のセルの区切り線だけ消す。

        // ボタンの書式を変更
        Buttonformat().underButtonformat(button: underButton)

        // テスト用のデータを配列に入れる
        ProcessArray().settingArray()

        print("カテゴリービューを表示")

        // トラッキングの許可
        if #available(iOS 14, *) {
           ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
              switch status {
              case .authorized:
                 // IDFA取得
                 print("IDFA: \(ASIdentifierManager.shared().advertisingIdentifier)")
                 print("success")
              case .denied, .restricted, .notDetermined:
                 print("failure")
              @unknown default:
                 fatalError()
              }
           })
        }

    }

    @IBAction func tapImage(_ sender: UITapGestureRecognizer) {
        print("イメージが押された")
    }

    // カテゴリー画面に戻ってきた時の処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("カテゴリーに戻ってきた※タスク数が変化しているか確認")
        tableView.reloadData()
    }

    // 画面推移の時の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        switch segue.identifier ?? "" {
        case K.SegueIdentifier.CategoryToTask:
            guard let taskVC = segue.destination as? TaskViewController else { return }
            guard let categoryIndex = categoryIndex else { return }
            taskVC.beforeExistingItem = appDelegate?.itemArray[categoryIndex]
            taskVC.taskMode = .check
            taskVC.transitionSource = .categoryEdit(categoryIndex)

        default:
            break
        }

    }

    // キャンセルしてカテゴリー画面へ戻ってくる
    @IBAction private func exitCancel(segue: UIStoryboardSegue) {
    }

    // 完了してカテゴリー画面へ戻ってくる
    @IBAction private func exitDone(segue: UIStoryboardSegue) {

        guard let inputTVC = segue.source as? InputTableViewController else { return }

        switch inputTVC.inputMode {
        case .add:
            let addItem = inputTVC.addItem

            ProcessArray().addCategory(item: addItem)
        case .edit:
            guard let editItem = inputTVC.editItem else { return }
            guard let categoryIndex = inputTVC.categoryIndex else { return }

            ProcessArray().editCategory(item: editItem, categoryIndex: categoryIndex)
        }

        tableView.reloadData()

        print("配列への追加処理完了")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CategoryViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        appDelegate!.itemArray.count
    }

    // セルに表示するデータを指定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = K.CellIdentifier.CategoryCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? CategoryTableViewCell
        let item = appDelegate!.itemArray[indexPath.row]

        cell?.configureCategory(item: item)

        return cell!
    }

    // セルタップ処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        categoryIndex = indexPath.row

        // タスクビューへの推移
        performSegue(withIdentifier: K.SegueIdentifier.CategoryToTask, sender: nil)
    }

    // セルを削除(カテゴリー削除)
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            appDelegate?.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
