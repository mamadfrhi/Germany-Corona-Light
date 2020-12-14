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

internal
class LocationErrorState: LocationErrorStateable {
    
    // MARK: Variables
    
    private let lightsView: LightsView
    private var localizedErrorMessage: String? = nil
    private var locationError: LocationError? = nil
    
    // MARK: Init
    
    init(lightsView: LightsView) {
        self.lightsView = lightsView
    }
    
    // MARK: Functions
    
    func setLocationErrorState(locationError: LocationError) {
        // Setup
        setupState(with: locationError)
        // Perform changes
        handleGeneralViews()
        handleButtons()
        sendMessageView()
    }
    
    private func setupState(with locationError: LocationError) {
        self.localizedErrorMessage = locationError.errorDescription
            ?? "An error releated to location services occured!"
        self.locationError = locationError
    }
    
    private func handleGeneralViews() {
        // Handle Views
        self.lightsView.currentOnlineLight = .off
        
        // Description
        self.lightsView.resetDescriptionLabelConstraints(for: true)
        self.lightsView.changeDesciriptionLabel(text: localizedErrorMessage)
        
        // Gesture
        self.lightsView.handleStackViewGesture(isEnable: false)
    }
    private func handleButtons() {
        // Buttons
        self.lightsView.rulesPageButton.isHidden = true
        self.lightsView.retryButton.isHidden = false
    }
    private func sendMessageView() {
        guard let locationError = locationError ,
              let localizedErrorMessage = localizedErrorMessage
        else { return}
        
        // Show Error Messsage to user
        switch locationError {
        case .locationNotAllowedError:
            // Show modal message
            // It's a serious problem
            Toast.shared.showModal(description: localizedErrorMessage)
            
        case .outOfBavariaError, .badLocationError:
            // Show simple message view
            Toast.shared.showIn(body: localizedErrorMessage)
        }
    }
}

// TODO: Add template design pattern
// for all 3 states handling
