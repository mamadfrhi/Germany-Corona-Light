//
//  RulesVC.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit

class RulesVC : UIViewController {
    
    // MARK: Dependencies
    private var statusColor: LightColors
    private var rulesView: RulesView
    
    // MARK: Lifecycle
    init(statusColor: LightColors) {
        self.statusColor = statusColor
        self.rulesView = RulesView(frame: UIScreen.main.bounds)
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
    }
    
    // MARK: Setups
    private func setupRulesLabelText() {
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
        if var labelText = rulesView.statusLabel.text{
            labelText += statusColor.rawValue
            rulesView.statusLabel.text = labelText
        }
    }
    
    private func setupLightColor() {
        switch statusColor {
        case .darkRed:
            rulesView.statusLight.backgroundColor = UIColor(named: "DarkRed")
        case .red:
            rulesView.statusLight.backgroundColor = UIColor(named: "Red")
        case .yellow:
            rulesView.statusLight.backgroundColor = UIColor(named: "Yellow")
        case .green:
            rulesView.statusLight.backgroundColor = UIColor(named: "Green")
        case .off:
            break
        }
    }
}
