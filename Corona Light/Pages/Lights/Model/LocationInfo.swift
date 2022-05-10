//
//  LocationInfo.swift
//  Corona Light
//
//  Created by iMamad on 12/5/20.
//

import Foundation
import CoreLocation

struct LocationInfo {
    private var clLocation: CLLocation
    var country: String?
    var state: String?
    var town: String?
    
    init(clLocation: CLLocation) { self.clLocation = clLocation }
    
    func get(completion: @escaping (LocationInfo)->()) {
        let geocoder = CLGeocoder()
        let germanyLocale = Locale(identifier: "de")
        
        geocoder.reverseGeocodeLocation(clLocation, preferredLocale: germanyLocale) {
            placeMarks, error in
            guard let placeMark = placeMarks?.first, error == nil else { return }
            var locationInfo = LocationInfo(clLocation: clLocation)
            locationInfo.country = placeMark.country
            locationInfo.state = placeMark.administrativeArea
            locationInfo.town = placeMark.subAdministrativeArea
            completion(locationInfo)
        }
    }
}
