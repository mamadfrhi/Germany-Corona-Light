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
        // Buttons
        self.lightsView.rulesPageButton.isHidden = false
        self.lightsView.retryButton.isHidden = true
        
        // Label
        self.lightsView.descriptionLabel.isHidden = false
    }
}
