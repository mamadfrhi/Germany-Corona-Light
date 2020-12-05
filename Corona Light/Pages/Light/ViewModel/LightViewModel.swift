//
//  LightViewModel.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation

class LightViewModel: Networkable,
                      NetworkDelegate,
                      LocationDelegate {
    
    //MARK:- Dependencies
    private let api: Networkable!
    
    // Inject -> network + location manager + notification
    init(api: Networkable) {
        self.api = api
    }
    
    //MARK:- Location
    func didUpdateLocation(to state: String) {
        
    }
    
    //MARK:- Network
    func getStats(of state: String) {
        
    }
    func didGetStats(numberOfDeath: Int) {
        
    }
}
