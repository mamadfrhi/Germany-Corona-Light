//
//  LightsManager.swift
//  Corona Light
//
//  Created by iMamad on 12/7/20.
//

import UIKit

protocol LightManagerable {
    var lights: [Light] { get}
    var currentOnlineLight: StatusColors { get set}
    
    func makeLights()
}

internal
class LightsManager {
    
    // MARK: Variables
    var currentOnlineLight: StatusColors = .off {
        didSet {
            if currentOnlineLight != .off {
                turnOn(lightColor: currentOnlineLight)
            } else {
                blinkAllLights()
            }
        }
    }
    var lights: [Light] = []
    
    // MARK: Init
    init() {
        self.makeLights()
    }
    
    // MARK: Light Functions
    private func turnOn(lightColor: StatusColors) {
        lights.forEach { (light) in
            if light.colorName == lightColor.rawValue {
                UIView.animate(withDuration: 1) {
                    light.circleView.alpha = 1
                    light.circleView.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                }
            }else {
                UIView.animate(withDuration: 0.8) {
                    light.circleView.alpha = 0.3
                    light.circleView.transform = .identity
                }
            }
        }
    }
    private func blinkAllLights() {
        lights.forEach { (light) in
            light.circleView.transform = .identity
            light.circleView.blink()
        }
    }
}

//LightManagerable
extension LightsManager: LightManagerable {
    func makeLights(){
        var lights : [Light] = []
        for stateColorName in StatusColors.allCases {
            guard let color = UIColor.init(named: stateColorName.rawValue) else {
                continue
            }
            let circleView = CircleView(color: color)
            let light = Light(circleView: circleView,
                              colorName: stateColorName.rawValue)
            lights.append(light)
        }
        self.lights = lights
    }
}
