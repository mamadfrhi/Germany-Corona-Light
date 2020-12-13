//
//  Network.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import Foundation
import SwiftyJSON
import Moya


enum CoronaService {
    case getStatsOf(state: String)
}

extension CoronaService: TargetType {
    var baseURL: URL {
        return URL(string: "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query")!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getStatsOf(let stateName):
            var parameters = Parameter()
            parameters["where"] = "GEN like '\(stateName)'"
            parameters["outFields"] = "cases7_per_100k"
            parameters["returnGeometry"] = "false"
            parameters["outSR"] = "4326"
            parameters["f"] =  "json"
            return parameters
        }
    }
    
    var headers: [String : String]? {
        return ["Accept":"*/*",
                "Accept-Encoding":"gzip, deflate, br"]
    }
    
    var sampleData: Data {
        //TODO: Do it for test
        return Data()
    }
    
    var task: Task {
        return .requestParameters(parameters: parameters!,
                                  encoding: URLEncoding.queryString)
    }
}
