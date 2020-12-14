//
//  Bundle+infoPlistValue.swift
//  Corona Light
//
//  Created by iMamad on 12/14/20.
//

import Foundation


extension Bundle {
    static func infoPlistValue(forKey key: String) -> Any? {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) else {
           return nil
        }
        return value
    }
}
