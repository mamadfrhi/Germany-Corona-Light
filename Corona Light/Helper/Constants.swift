//
//  Constants.swift
//  Corona Light
//
//  Created by iMamad on 12/10/20.
//

import UIKit



internal let screenBounds = UIScreen.main.bounds
internal typealias Parameter = [String : Any]

internal
enum StatusColors: String, CaseIterable {
    case darkRed = "DarkRed"
    case red = "Red"
    case yellow = "Yellow"
    case green = "Green"
    case off
}
