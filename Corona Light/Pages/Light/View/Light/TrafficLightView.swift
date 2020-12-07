//
//  TrafficLight.swift
//  Corona Light
//
//  Created by iMamad on 12/7/20.
//

import UIKit
import SnapKit

class TrafficLightView: UIView {
    
    // MARK: Dependency
    private var lightManager: LightManagerable!
    var currentOnlineLight: LightColors = .green{
        willSet {
            lightManager.currentOnlineLight = newValue
        }
    }
    
    //MARK: Views
    private var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    private var contentView: UIView = {
        let vw = UIView()
        vw.cornerRadius = 50
        vw.backgroundColor = .black
        return vw
    }()
    
    var descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 4
        return lbl
    }()
    
    //MARK: Size
    private var stackViewHeight: CGFloat {
        return (self.frame.height * 0.6)
    }
    private var singleLightHeight: CGFloat {
        let lighCount = CGFloat(4)
        let marginValue = CGFloat( 5 + 5)
        let lightSpace = stackViewHeight / lighCount
        let lightWithMarginSpace = lightSpace - marginValue
        return lightWithMarginSpace
    }
    
    //MARK: Init
    init(frame: CGRect, lightManager: LightManagerable) {
        super.init(frame: frame)
        self.lightManager = lightManager
        self.backgroundColor = .white
        setupContentView()
        setupStackView()
        setupDescriptionLabel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup
    // ContentView
    private func setupContentView() {
        self.addSubview(self.contentView)
        addContentViewConstraints()
    }
    private func addContentViewConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.width.equalTo(self.singleLightHeight + 50 + 50)
            make.height.equalTo(self.stackViewHeight + 20 + 20)
            make.centerX.equalToSuperview()
        }
    }
    // StackView
    private func setupStackView() {
        self.contentView.addSubview(stackView)
        addStackViewConstraints()
        addLightsToStackView()
    }
    private func addStackViewConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(self.singleLightHeight)
            make.height.equalTo(self.stackViewHeight)
            make.centerX.equalToSuperview()
        }
    }
    private func addLightsToStackView(){
        let lights = lightManager.lights
        for light in lights {
            stackView.addArrangedSubview(light.circleView)
        }
    }
    // DescriptionLabel
    private func setupDescriptionLabel() {
        self.addSubview(descriptionLabel)
        addDescriptionLabelConstraints()
    }
    private func addDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(30)
//            make.right.equalToSuperview().offset(-30)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(100)
        }
    }
}
