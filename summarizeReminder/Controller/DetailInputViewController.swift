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
        dayOfWeek: ["月曜日", "火曜日", "水曜日", "木曜日", "金曜日", "土曜日", "日曜日"],
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
        default:
            print("存在しないモードが指定されている")
            return 0
        }
    }

    // セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let identifier = K.CellIdentifier.DetailInputLabelCell
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier,
                                                 for: indexPath) as? DetailInputTableViewCell

        // 選択されているモードに合わせてセルの表示内容を変更
        guard let detailInputMode = detailInputMode else { return cell!}
        switch detailInputMode {
        case .categorySelect:

            cell?.detailInputLabel?.text = appDelegate?.itemArray[indexPath.row].category

            if indexPath.row == categoryIndex {
                cell?.detailInputImage.image = UIImage(systemName: "checkmark")
                cell?.detailInputImage.tintColor = .orange
                cell?.detailInputImage.alpha = 1
            } else {
                cell?.detailInputImage.image = nil
                cell?.detailInputImage.alpha = 0
            }

            return cell!

        case .repeatSelect:

            cell?.detailInputLabel?.text = weekArray.dayOfWeek[indexPath.row]

            if weekArray.isWeekCheck[indexPath.row] {
                cell?.detailInputImage.image = UIImage(systemName: "checkmark")
                cell?.detailInputImage.tintColor = .orange
                cell?.detailInputImage.alpha = 1
            } else {
                cell?.detailInputImage.image = nil
                cell?.detailInputImage.alpha = 0
           }

            return cell!
        }
    }

    // セルをタップした時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // セルの選択を解除

        // InputTableViewControllerを呼び出し
        guard let navigation = self.navigationController else { return }
        guard let inputTVC = navigation.viewControllers[0] as? InputTableViewController else { return }

        guard let detailInputMode = detailInputMode else { return }
        switch detailInputMode {
        case .categorySelect:
            categoryIndex = indexPath.row

            inputTVC.categoryIndex = categoryIndex
            inputTVC.editItem = appDelegate?.itemArray[categoryIndex!] // editItemの初期化

        case .repeatSelect:

            weekArray.isWeekCheck[indexPath.row].toggle()

            switch inputTVC.inputMode {
            case .add:
                inputTVC.addItem.isWeekCheck = weekArray.isWeekCheck
            case .edit:
                inputTVC.editItem?.isWeekCheck = weekArray.isWeekCheck
            }
        }
        tableView.reloadData()
    }

    // セルが選択されそうな時の処理
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let detailInputMode = detailInputMode else { return nil }
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
        }
    }

}
