//
//  LocationError.swift
//  Corona Light
//
//  Created by iMamad on 12/11/20.
//

import Foundation

enum LocationError {
    case locationNotAllowedError
    case outOfBavariaError
    case badLocationError
}

extension LocationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .locationNotAllowedError:
            let message = "locationPermissionAlert".localized()
            return message
        case .outOfBavariaError:
            let message = "locationOutOfBavariaError".localized()
            return message
        case .badLocationError:
            let message = "locationDetectionError".localized()
            return message
        }
    }
}
