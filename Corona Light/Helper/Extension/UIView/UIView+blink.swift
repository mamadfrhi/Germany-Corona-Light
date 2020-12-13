//
//  UIView+blink.swift
//  Corona Light
//
//  Created by iMamad on 12/11/20.
//

import UIKit


extension UIView {
    func blink() {
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 2
        flash.fromValue = 1
        flash.toValue = 0.3
        flash.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = .infinity
        layer.add(flash, forKey: nil)
    }
}
