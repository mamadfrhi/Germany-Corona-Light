//
//  NetworkManager.swift
//  Corona Light
//
//  Created by iMamad on 12/6/20.
//

import SwiftyJSON
import Moya


protocol CoronaServiceAdaptable {
    var provider: MoyaProvider<CoronaService> { get }
    func getStats(of state: String, completion: @escaping (Int?, NetworkError?)->())
}

// CoronaAPI = adapter
struct CoronaAPI : CoronaServiceAdaptable {
    var provider = MoyaProvider<CoronaService>()
    
    func getStats(of state: String, completion: @escaping (Int?, NetworkError?) -> ()) {
        
        provider.request(.getStatsOf(state: state)) {
            (result) in
            switch result {
            case let .success(response):
                let json = JSON(response.data)
                let feature = json["features"][0]
                if let incidents =
                    feature["attributes"]["cases7_per_100k"].int {
                    completion(incidents, nil)
                }else {
                    completion(nil, .serverDataError)
                    print("Server Error Occured.")
                }
                
            case .failure(let failure):
                let errorDescription = failure.localizedDescription
                completion(nil, .requestError(errorDescription))
                print("Network Error Occured.")
            }
        }
    }
}
