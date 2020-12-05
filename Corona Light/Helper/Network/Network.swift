//
//  Network.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation

protocol Networkable {
    func getStats(of state: String)
}

protocol NetworkDelegate {
    func didGetStats(numberOfDeath: Int)
}

class Networking: Networkable {
    func getStats(of state: String) {
        // call api
        // parse
        // call delegate
    }
}
