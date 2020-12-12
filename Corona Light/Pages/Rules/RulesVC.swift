//
//  RulesVC.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit

class RulesVC : UIViewController {
    
    // MARK: Dependencies
    private var statusColor: StatusColors
    private var rulesView: RulesView
    
    // MARK: Lifecycle
    init(statusColor: StatusColors) {
        self.statusColor = statusColor
        self.rulesView = RulesView(frame: screenBounds)
        super.init(nibName: nil, bundle: nil)
        // Setups
        setupLightColor()
        setupStatusLabel()
        setupRulesLabelText()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = rulesView
        self.title = "Restrictions"
    }
    
    // MARK: Setups
    private func setupRulesLabelText() {
        rulesView.rulesTextView.layer.bottomAnimation(duration: 3)
        switch statusColor {
        case .darkRed:
            let rulesText = NSLocalizedString("darkRedStatusRules",
                                              comment: "Dark Red Status Rules")
            rulesView.rulesTextView.text = rulesText
        case .red:
            let rulesText = NSLocalizedString("redStatusRules",
                                              comment: "Red Status Rules")
            rulesView.rulesTextView.text = rulesText
        case .yellow:
            let rulesText = NSLocalizedString("yellowStatusRules",
                                              comment: "Yellow Status Rules")
            rulesView.rulesTextView.text = rulesText
        case .green:
            let rulesText = NSLocalizedString("greenStatusRules",
                                              comment: "Green Status Rules")
            
            rulesView.rulesTextView.text = rulesText
        case .off:
            break
        }
    }
    
    private func setupStatusLabel() {
        rulesView.statusLabel.layer.leftAnimation(duration: 3)
        if var labelText = rulesView.statusLabel.text{
            // add name of color end of string
            labelText += statusColor.rawValue
            rulesView.statusLabel.text = labelText
        }
    }
    
    private func setupLightColor() {
        switch statusColor {
        case .darkRed:
            rulesView.set(statusColor: .darkRed)
        case .red:
            rulesView.set(statusColor: .red)
        case .yellow:
            rulesView.set(statusColor: .yellow)
        case .green:
            rulesView.set(statusColor: .green)
        case .off:
            break
        }
    }
}
