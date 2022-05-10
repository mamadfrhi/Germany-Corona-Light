//
//  NetworkErrorState.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

protocol NetworkErrorStateable {
    func setNetworkErrorState(networkError: NetworkError)
}

class NetworkErrorState: NetworkErrorStateable {
    
    // MARK: Variables
    private let lightsView: LightsView
    private var localizedErrorMessage: String?
    private var networkError: NetworkError?
    
    // MARK: Init
    required init(lightsView: LightsView) { self.lightsView = lightsView }
    
    // MARK: Functions
    func setNetworkErrorState(networkError: NetworkError) {
        setupState(with: networkError)
        configState() // call template
    }
    
    private func setupState(with networkError: NetworkError) {
        self.localizedErrorMessage = networkError.errorDescription
        ?? "An error related to location services occurred!"
        self.networkError = networkError
    }
}

extension NetworkErrorState: Stateable {
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
        guard let networkError = networkError ,
              let localizedErrorMessage = localizedErrorMessage
        else { return}
        
        // Show error message to user
        switch networkError {
        case .requestError:
            Toast.shared.showIn(body: localizedErrorMessage)
            
        case .serverDataError:
            Toast.shared.showIn(body: localizedErrorMessage)
        }
    }
}
