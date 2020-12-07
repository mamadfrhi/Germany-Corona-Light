//
//  NetworkManager.swift
//  Corona Light
//
//  Created by iMamad on 12/6/20.
//

import Foundation
import Moya
import SwiftyJSON

struct NetworkManager: Networkable {
    var provider = MoyaProvider<CoronaAPI>()
    
    func getStats(of state: String, completion: @escaping (Int?, String?) -> ()) {
        print("I'm sending request!")
        provider.request(.getStatsOf(state: state)) {
            (result) in
            switch result {
            case let .success(response):
                let json = JSON(response.data)
                let feature = json["features"][0]
                if let incidents = feature["attributes"]["cases7_per_100k"].int {
                    completion(incidents, nil)
                }else {
                    completion(nil, "Crorona statstics of your state isn't there on the server!")
                }
                
            case .failure(let failure):
                let errorDescription = failure.localizedDescription
                completion(nil, errorDescription)
            }
        }
    }
}
