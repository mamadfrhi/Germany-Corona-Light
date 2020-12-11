//
//  LightManager.swift
//  Corona Light
//
//  Created by iMamad on 12/7/20.
//

import UIKit

protocol LightManagerable {
    var lights: [Light] { get}
    var currentOnlineLight: LightColors { get set}
    
    func makeLights()
}
enum LightColors: String, CaseIterable {
    case darkRed = "DarkRed"
    case red = "Red"
    case yellow = "Yellow"
    case green = "Green"
    case off
}

class LightManager {
    //TODO: Do it with RX
    // MARK: Variables
    var currentOnlineLight: LightColors = .off {
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
    
    // TODO: Animate
    // MARK: Light Functions
    private func turnOn(lightColor: LightColors) {
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
extension LightManager: LightManagerable {
    func makeLights(){
        var lights : [Light] = []
        for stateColorName in LightColors.allCases {
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

// MARK: CircleView
class CircleView: UIView {
    var color: UIColor!
    
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
