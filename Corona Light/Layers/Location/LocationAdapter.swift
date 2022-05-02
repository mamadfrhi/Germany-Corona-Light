//
//  LocationAdapter.swift
//  Corona Light
//
//  Created by iMamad on 12/5/20.
//

import Foundation
import CoreLocation

class LocationAdapter {
    
    let geocoder = CLGeocoder()
    
    func getLocationInfo(from location: CLLocation,
                         completion: @escaping (LocationInfo?) -> Void) {
        // Force to get German name of state
        // if the device's language setted in English
        let germanyLocale = Locale(identifier: "de")
        
        geocoder.reverseGeocodeLocation(location,
                                        preferredLocale: germanyLocale) {
            placemarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            let locationInfo = LocationInfo(country: placemark.country,
                                            state: placemark.administrativeArea,
                                            town: placemark.subAdministrativeArea)
            completion(locationInfo)
        }
    }
}
