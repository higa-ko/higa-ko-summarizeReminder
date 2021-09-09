//
//  ViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

    // 下にある+ボタン
    @IBOutlet private weak var underButton: UIButton!

    private var categoryIndex: Int?
    private let shaer = Buttonformat()

    // 画面実行時の処理
    override func viewDidLoad() {
        super.viewDidLoad()

        // ボタンの書式を変更
        shaer.underButtonformat(button: underButton)

        print("カテゴリービューを表示")
    }

    // カテゴリー画面に戻ってきた時の処理
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)

           tableView.reloadData()
       }

        // 画面推移の時の処理
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

            switch segue.identifier ?? "" {
            case K.SegueIdentifier.CategoryToTask:
                guard let taskVC = segue.destination as? TaskViewController else { return }
                guard let categoryIndex = categoryIndex else { return }
                taskVC.mode = .check(categoryIndex)

            default:
                print("存在しないidentifierが指定されている")
            }

        }

    // キャンセルしてカテゴリー画面へ戻ってくる
    @IBAction private func exitCancel(segue: UIStoryboardSegue) {
    }

    // 完了してカテゴリー画面へ戻ってくる
    @IBAction private func exitDone(segue: UIStoryboardSegue) {
        // 配列への追加処理
        ProcessArray().addCategory()

        tableView.reloadData()
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
}
