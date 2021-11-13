//
//  Constants.swift
//  summarizeReminder
//
//  Created by 葡萄酒 on 2021/08/14.
//

// swiftlint:disable type_name
struct K {
// swiftlint:enable type_name

    struct CellIdentifier {
        static let CategoryCell = "CategoryCell"

        static let DisplayTaskyCell = "DisplayTaskCell"
        static let InputTaskCell = "InputTaskCell"

        // 問題なさそうなら削除
//        static let NewCategoryCheckCell = "NewCategoryCheckCell"
//        static let CategoryInputCell = "CategoryInputCell"
//        static let CategorySelectCell = "CategorySelectCell"
//        static let NoticeCheckCell = "NoticeCheckCell"
//        static let TimeSelectCell = "TimeSelectCell"
//        static let RepeatSelectCell = "RepeatSelectCell"
//        static let TaskAddCell = "TaskAddCell"

        static let DetailInputLabelCell = "DetailInputLabelCell"
        static let DetailInputTextFieldCell = "DetailInputTextFieldCell"
    }

    struct SegueIdentifier {
        static let CategoryToTask = "CategoryToTask"
        static let InputToSelect = "InputToSelect"
        static let InputToTask = "InputToTask"
    }
}
