//
//  CoronaAPI.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

// Interface
protocol CoronaNetworkable {
    func getIncidents(of townName: String)
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
    func getIncidents(of townName: String) {
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
