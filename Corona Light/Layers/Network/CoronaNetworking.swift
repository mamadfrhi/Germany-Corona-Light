//
//  CoronaAPI.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

// Interface
protocol CoronaNetworkable {
    func getIncidents(of townName: String,
                      previousRequestTime: Date?)
}
// Delegate
protocol CoronaNetworkableDelegate {
    func isLoading(loading: Bool)
    func raisedNetworkError(error: NetworkError)
    func didGet(incidents: Int)
}

// Implementation
class CoronaNetworking: CoronaNetworkable {
    
    // MARK: Variables
    private var _api : CoronaAPI
    var delegate: CoronaNetworkableDelegate?
    
    // MARK: Init
    init(coronaAPI: CoronaAPI) { self._api = coronaAPI }
    
    // MARK: Functions
    func getIncidents(of townName: String,
                      previousRequestTime: Date?) {
        guard requestAllowed(previousRequstTime: previousRequestTime,
                             currentTime: Date()) == true else { return}
        
        // Call API
        delegate?.isLoading(loading: true)
        _api.getStats(of: townName) {
            [unowned self]
            (incidents, networkError) in
            // Stop loading
            delegate?.isLoading(loading: false)
            
            // Handle Errors
            if let networkError = networkError {
                self.delegate?.raisedNetworkError(error: networkError)
                return
            }
            
            // Result
            if let incidents = incidents {
                self.delegate?.didGet(incidents: incidents)
            }
        }
    }
}

// MARK: Time related functions
extension CoronaNetworking {
    private func timeDifferenceInSeconds(from: Date,
                                         until: Date) -> Int? {
        let diffComponents = Calendar.current.dateComponents([.second],
                                                             from: from,
                                                             to: until)
        return diffComponents.second
    }
    
    // Check if request 30 seconds later send
    private func requestAllowed(previousRequstTime: Date?,
                                currentTime: Date) -> Bool {
        
        // If previousTime is nil -> it's first request -> return true
        guard let previousRequestTime = previousRequstTime
        else { return true}
        
        let differenceInSeconds = timeDifferenceInSeconds(from: previousRequestTime,
                                                          until: currentTime)
        
        if let seconds = differenceInSeconds, seconds > 30 {
            return true
        }else {
            return false
        }
    }
}
