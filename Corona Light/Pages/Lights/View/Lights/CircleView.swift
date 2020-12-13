//
//  CircleView.swift
//  Corona Light
//
//  Created by iMamad on 12/13/20.
//

import UIKit

// MARK: CircleView
class CircleView: UIView {
    var color: UIColor! {
        didSet {
            self.backgroundColor = color
        }
    }
    
    init(color: UIColor) {
        self.color = color
        super.init(frame: .zero)
        self.backgroundColor = color
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = bounds.midX
    }
}
