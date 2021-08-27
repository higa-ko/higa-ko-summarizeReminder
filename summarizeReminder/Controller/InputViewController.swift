//
//  InputViewController.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/16.
//

import UIKit

class InputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //AppDelegateの呼び出し
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        //行数によって表示するセルを設定
        switch indexPath.row {
        
        case 0:
            identifier = K.CellIdentifier.NewCategoryCheckCell
            
        case 1:
            if appDelegate.newCategoryCheck {
                identifier = K.CellIdentifier.CategoryInputCell
            } else {
                identifier = K.CellIdentifier.CategorySelectCell
            }
            
        case 2:
            identifier = K.CellIdentifier.NoticeCheckCell
            
        case 3:
            if appDelegate.noticeCheck {
                identifier = K.CellIdentifier.TimeSelectCell
            } else {
                identifier = K.CellIdentifier.BlankCell
            }
            
        case 4:
            if appDelegate.noticeCheck {
                identifier = K.CellIdentifier.RepeatSelectCell
            } else {
                identifier = K.CellIdentifier.BlankCell
            }
            
        case 5:
            identifier = K.CellIdentifier.TaskAddCell
            
        default:
            print("エラー")
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath) as! InputTableViewCell
        cell.cellDegate = self
        
        return cell
    }
    
    func newCategoryActionSwitch() {
        tableView.reloadData()
    }
    
    func noticeActionSwitch() {
        tableView.reloadData()
    }
}
