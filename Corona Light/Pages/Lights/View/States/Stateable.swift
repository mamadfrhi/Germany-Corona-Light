//
//  Stateable.swift
//  Corona Light
//
//  Created by iMamad on 10.05.22.
//

import Foundation

// Template Design Patter //

protocol Stateable {
    func handleGeneralViews()
    func handleButtons()
    func sendMessageView()
    func configState()
}
extension Stateable {
    func configState() {
        handleGeneralViews()
        handleButtons()
        sendMessageView()
    }
}
