//
//  NetworkErrorState.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

protocol NetworkErrorStateable {
    func setNewtorkErrorState(networkError: NetworkError)
}

class NewtorkErrorState: NetworkErrorStateable {
    
    // MARK: Variables
    
    private let lightsView: LightsView
    private var localizedErrorMessage: String?
    private var networkError: NetworkError?
    
    // MARK: Init
    
    required init(lightsView: LightsView) { self.lightsView = lightsView }
    
    // MARK: Functions
    
    func setNewtorkErrorState(networkError: NetworkError) {
        // Setup
        setupState(with: networkError)
        // Perform changes
        handleGeneralViews()
        handleButtons()
        sendMessageView()
    }
    
    private func setupState(with networkError: NetworkError) {
        self.localizedErrorMessage = networkError.errorDescription
            ?? "An error releated to location services occured!"
        self.networkError = networkError
    }
    
    private func handleGeneralViews() {
        // Handle Views
        self.lightsView.currentOnlineLight = .off
        
        // Description
        self.lightsView.resetDescriptionLabelConstraints(for: true)
        self.lightsView.changeDescriptionLabel(text: localizedErrorMessage)
        
        // Gesture
        self.lightsView.handleStackViewGesture(isEnable: false)
    }
    private func handleButtons() {
        // Buttons
        self.lightsView.rulesPageButton.isHidden = true
        self.lightsView.retryButton.isHidden = false
    }
    private func sendMessageView() {
        guard let networkError = networkError ,
              let localizedErrorMessage = localizedErrorMessage
        else { return}
        
        // Show Error Messsage to user
        // Like notification
        switch networkError {
        case .requestError:
            Toast.shared.showIn(body: localizedErrorMessage)
            
        case .serverDataError:
            Toast.shared.showIn(body: localizedErrorMessage)
        }
    }
}
