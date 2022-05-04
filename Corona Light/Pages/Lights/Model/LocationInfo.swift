//
//  LocationInfo.swift
//  Corona Light
//
//  Created by iMamad on 12/5/20.
//

import Foundation
import CoreLocation

class LocationInfo {
    
    private var clLocation: CLLocation
    var country: String?
    var state: String?
    var town: String?
    
    init(clLocation: CLLocation) { self.clLocation = clLocation }
    
    func convert(completion: @escaping (LocationInfo)->()) {
        let geocoder = CLGeocoder()
        let germanyLocale = Locale(identifier: "de")
        
        geocoder.reverseGeocodeLocation(clLocation, preferredLocale: germanyLocale) {
            [weak self]
            placeMarks, error in
            guard let self = self else { return }
            guard let placeMark = placeMarks?.first, error == nil else { return }
            self.country = placeMark.country
            self.state = placeMark.administrativeArea
            self.town = placeMark.subAdministrativeArea
            completion(self)
        }
    }
}
