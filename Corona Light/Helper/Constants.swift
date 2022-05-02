//
//  Constants.swift
//  Corona Light
//
//  Created by iMamad on 12/10/20.
//

import UIKit



let screenBounds = UIScreen.main.bounds
typealias Parameter = [String : Any]

enum StatusColors: String, CaseIterable {
    case darkRed = "DarkRed"
    case red = "Red"
    case yellow = "Yellow"
    case green = "Green"
    case off
}


extension Date {
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
}
