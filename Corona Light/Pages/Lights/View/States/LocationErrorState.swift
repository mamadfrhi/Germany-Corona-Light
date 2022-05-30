//
//  LocationErrorState.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

protocol LocationErrorStateable {
    func setLocationErrorState(locationError: LocationError)
}

class LocationErrorState: LocationErrorStateable {
    
    // MARK: Variables
    private let lightsView: LightsView
    private var localizedErrorMessage: String?
    private var locationError: LocationError?
    
    // MARK: Init
    required init(lightsView: LightsView) { self.lightsView = lightsView }
    
    // MARK: Functions
    func setLocationErrorState(locationError: LocationError) {
        setupState(with: locationError)
        configState() // call template
    }
    
    private func setupState(with locationError: LocationError) {
        self.localizedErrorMessage = locationError.errorDescription
            ?? "An error releated to location services occured!"
        self.locationError = locationError
    }
}

// MARK: Template
extension LocationErrorState: Stateable {
    func handleGeneralViews() {
        // Handle Views
        self.lightsView.currentOnlineLight = .off
        
        // Description
        self.lightsView.resetDescriptionLabelConstraints(for: true)
        self.lightsView.changeDescriptionLabel(text: localizedErrorMessage)
        
        // Gesture
        self.lightsView.handleStackViewGesture(isEnable: false)
    }
    func handleButtons() {
        self.lightsView.rulesPageButton.isHidden = true
        self.lightsView.retryButton.isHidden = false
    }
    func sendMessageView() {
        guard let locationError = locationError ,
              let localizedErrorMessage = localizedErrorMessage
        else { return}
        
        // Show Error Message to user
        switch locationError {
        case .locationNotAllowedError:
            // Show modal message - it's a serious problem
            Toast.shared.showModal(description: localizedErrorMessage)
            
        case .outOfBavariaError, .badLocationError:
            // Show simple message view
            Toast.shared.showIn(body: localizedErrorMessage)
        }
    }
}
