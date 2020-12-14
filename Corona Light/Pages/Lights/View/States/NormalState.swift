//
//  NormalState.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

protocol NormalStateable {
    func setNormlaState()
}

internal
class NormalState: NormalStateable {
    
    private let lightsView: LightsView
    
    init(lightsView: LightsView) {
        self.lightsView = lightsView
    }
    
    // MARK: Functions
    
    func setNormlaState() {
        // Perform changes
        handleGeneralViews()
    }
    
    private func handleGeneralViews() {
        
        self.lightsView.resetDescriptionLabelConstraints(for: false)
        
        // Buttons
        self.lightsView.rulesPageButton.isHidden = false
        self.lightsView.retryButton.isHidden = true
        
        // Label
        self.lightsView.descriptionLabel.isHidden = false
        
        // Gesture
        self.lightsView.handleStackViewGesture(isEnable: true)
    }
}
