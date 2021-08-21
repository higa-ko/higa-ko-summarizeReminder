//
//  InputViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

class InputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    //InputTableViewCellを呼び出し
    let InputTVC = InputTableViewCell()

    override func viewDidLoad() {
        super.viewDidLoad()

        print("いんぽーとビュー起動")
    }

    //表示するセルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6 //現時点のマックス行数を入れておく
    }
    
    //セルに表示する内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var identifier: String?
        let cell: UITableViewCell
        
        //行数によって表示するセルを設定
        switch indexPath.row {
        
        case 0:
            identifier = K.CellIdentifier.NewCategoryCheckCell
        
        case 1:
            identifier = K.CellIdentifier.CategoryInputCell
            
        case 2:
            identifier = K.CellIdentifier.NoticeCheckCell
        
        case 3:
            identifier = K.CellIdentifier.TimeSelectCell
            
        case 4:
            identifier = K.CellIdentifier.RepeatSelectCell

        case 5:
            identifier = K.CellIdentifier.TaskAddCell

        default:
            print("エラー")
        }
        
        cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath)

        return cell
    }
}
