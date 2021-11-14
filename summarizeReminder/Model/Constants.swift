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

        static let DetailInputLabelCell = "DetailInputLabelCell"
    }

    struct SegueIdentifier {
        static let CategoryToTask = "CategoryToTask"
        static let CategoryToInput = "CategoryToInput"
        static let InputToSelect = "InputToSelect"
        static let InputToTask = "InputToTask"
    }

    struct SavingKey {
        static let ItemArrayKey = "ItemArrayKey"
    }
}
