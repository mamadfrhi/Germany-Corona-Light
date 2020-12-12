//
//  String+localized.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

extension String {
    func localized(bundle: Bundle = .main, tableName: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: tableName, value: "**\(self)**", comment: "")
    }
}
