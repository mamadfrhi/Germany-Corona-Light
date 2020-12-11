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
            let message = NSLocalizedString("locationPermissionAlert",
                                            comment: "Location permission message")
            return message
        case .outOfBavariaError:
            let message = NSLocalizedString("locationOutOfBavariaError",
                                            comment: "Location permission message")
            return message
        case .badLocationError:
            let message = NSLocalizedString("locationDetectionError",
                                            comment: "Location permission message")
            return message
        }
    }
}
