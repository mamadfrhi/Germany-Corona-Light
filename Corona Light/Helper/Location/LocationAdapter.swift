//
//  LocationAdapter.swift
//  Corona Light
//
//  Created by iMamad on 12/5/20.
//

import Foundation
import CoreLocation

internal
class LocationAdapter {
    
    let geocoder = CLGeocoder()
    
    private func getTownName(from location: CLLocation,
                             completion: @escaping (String?) -> Void) {
        
        geocoder.reverseGeocodeLocation(location) {
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
            completion(placemark.subAdministrativeArea)
        }
    }
    
    func getLocationInfo(from location: CLLocation,
                         completion: @escaping (LocationInfo?) -> Void) {
        
        geocoder.reverseGeocodeLocation(location) {
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
