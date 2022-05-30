//
//  CodeView.swift
//  Corona Light
//
//  Created by iMamad on 12/12/20.
//

import Foundation

// *** Template Design Pattern ***
// For adding custom uiviews

protocol ViewCodeable {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension ViewCodeable {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    // make it optional
    func setupAdditionalConfiguration(){}
}
