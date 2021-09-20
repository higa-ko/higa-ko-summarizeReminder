//
//  DetailinputViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/09/19.
//

import UIKit

enum DetailInputMode {
    case categorySelect
    case repeatSelect
    case taskSelect
}

class DetailInputViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var detailInputMode: DetailInputMode?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.tableFooterView = UIView()  // 空のセルの区切り線だけ消す。

        guard let detailInputMode = detailInputMode else { return }
        switch detailInputMode {
        case .categorySelect:
            self.navigationItem.title = "カテゴリー"

        case .repeatSelect:
            self.navigationItem.title = "繰り返し設定"

        case .taskSelect:
            self.navigationItem.title = "タスク"
        }
        print("入力詳細画面を表示")

    }

}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension DetailInputViewController: UITableViewDataSource, UITableViewDelegate {
    // 表示するセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 // テスト用
    }

    // セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 選択されているモードに合わせてセルの表示内容を変更
        switch detailInputMode {
        case .categorySelect:
            let identifier = K.CellIdentifier.DetailInputLabelCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? DetailInputTableViewCell

            return cell!

        case .repeatSelect:
            let identifier = K.CellIdentifier.DetailInputLabelCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? DetailInputTableViewCell

            return cell!

        case .taskSelect:
            let identifier = K.CellIdentifier.DetailInputTextFieldCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? DetailInputTableViewCell

            return cell!

        default:
            print("存在しないモードが選択されている")
            let identifier = K.CellIdentifier.DetailInputLabelCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? DetailInputTableViewCell

            cell?.textLabel?.text = "存在しないモード"

            return cell!
        }
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch detailInputMode {
        case .categorySelect:
            return indexPath // セルを選択可能に変更
        case .repeatSelect:
            return indexPath // セルを選択可能に変更
        case .taskSelect:
            return nil // セルを選択不可に変更
        default:
            print("存在しないモードが選択されている")
            return nil // セルを選択不可に変更
        }
    }

}
