//
//  UIView+blink.swift
//  Corona Light
//
//  Created by iMamad on 12/11/20.
//

import UIKit

extension UIView {
    func blink() {
        self.alpha = 0.0;
        UIView.animate(withDuration: 1, //Time duration you want,
            delay: 0.0,
            options: [.curveEaseInOut, .autoreverse, .repeat],
            animations: { [weak self] in self?.alpha = 1.0 },
            completion: { [weak self] _ in self?.alpha = 0.2 })
    }
}
