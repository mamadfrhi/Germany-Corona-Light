//
//  CALayer+animation.swift
//  Corona Light
//
//  Created by iMamad on 12/11/20.
//

import UIKit


extension CALayer {
    func bottomAnimation(duration : CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .moveIn
        animation.subtype = .fromTop
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }
    
    func leftAnimation(duration : CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.duration = duration
        animation.type = .push
        animation.subtype = .fromLeft
        
        self.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
