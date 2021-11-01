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

struct Week {
    var dayOfWeek: [String]
    var isWeekCheck: [Bool]
}

class DetailInputViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var detailInputMode: DetailInputMode?

    private var taskArray: String?

    var categoryIndex: Int?

    var weekArray: Week = Week(
        dayOfWeek: ["日曜日", "月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日"],
        isWeekCheck: [false, false, false, false, false, false, false])

    // AppDelegateの呼び出し
    private weak var appDelegate = (UIApplication.shared.delegate as? AppDelegate)!

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

        switch detailInputMode {
        case .categorySelect:
            return (appDelegate?.itemArray.count)!
        case .repeatSelect:
            return weekArray.dayOfWeek.count
        case .taskSelect:
            return 1
        default:
            print("存在しないモードが指定されている")
            return 0
        }
    }

    // セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 選択されているモードに合わせてセルの表示内容を変更
        switch detailInputMode {
        case .categorySelect:
            let identifier = K.CellIdentifier.DetailInputLabelCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? DetailInputTableViewCell

            cell?.detailInputLabel?.text = appDelegate?.itemArray[indexPath.row].category

            if indexPath.row == categoryIndex {
                cell?.detailInputImage.tintColor = .orange
            } else {
                cell?.detailInputImage.tintColor = .white
            }

            return cell!

        case .repeatSelect:
            let identifier = K.CellIdentifier.DetailInputLabelCell
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                     for: indexPath) as? DetailInputTableViewCell

            cell?.detailInputLabel?.text = weekArray.dayOfWeek[indexPath.row]

            if weekArray.isWeekCheck[indexPath.row] {
                cell?.detailInputImage.tintColor = .orange
            } else {
                cell?.detailInputImage.tintColor = .white
            }

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

    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        guard let detailInputMode = detailInputMode else { return }
        switch detailInputMode {
        case .categorySelect:
            categoryIndex = indexPath.row

            // InputViewControllerに値を渡す
            guard let navigation = self.navigationController else { return }
            guard let inputTVC = navigation.viewControllers[0] as? InputTableViewController else { return }
            inputTVC.categoryIndex = categoryIndex
            inputTVC.editItem = appDelegate?.itemArray[categoryIndex!] // editItemの初期化
            print("editItemの初期化")

        case .repeatSelect:

            weekArray.isWeekCheck[indexPath.row].toggle()

            // InputViewControllerに値を渡す
            guard let navigation = self.navigationController else { return }
            guard let inputVC = navigation.viewControllers[0] as? InputTableViewController else { return }

            switch inputVC.inputMode {
            case .add:
                inputVC.addItem.isWeekCheck = weekArray.isWeekCheck
                print("add")
            case .edit:
                inputVC.editItem?.isWeekCheck = weekArray.isWeekCheck
                print("edit")
            }

        case .taskSelect:
            print("タスクの時の処理　今のところ使わない")
        }
        tableView.reloadData()
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch detailInputMode {
        case .categorySelect:
            // 選択済のカテゴリーの場合は選択不可にする
            if indexPath.row == categoryIndex {
                return nil // セルを選択不可に変更
            } else {
                return indexPath // セルを選択可能に変更
            }

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
