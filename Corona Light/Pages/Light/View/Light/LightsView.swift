//
//  LightsView.swift
//  Corona Light
//
//  Created by iMamad on 12/7/20.
//

import UIKit
import SnapKit

class LightsView: UIView {
    
    // MARK: Dependency
    private var lightManager: LightManagerable!
    var currentOnlineLight: StatusColors = .off{
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
    
    let descriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let rulesPageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("See limitations >>", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        return btn
    }()
    
    let retryButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.isHidden = true
        btn.setTitle("Retry!", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        return btn
    }()
    
    let stackViewTapGesture = UITapGestureRecognizer()
    
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
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.lightManager = LightsManager()
        self.backgroundColor = .white
        self.setupView()
//        setupContentView()
//        setupStackView()
//        setupDescriptionLabel()
//        setupRulesPageButtton()
//        setupRetryButtton()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LightsView : CodeView {
    
    // MARK: Template Functions
    
    func buildViewHierachy() {
        self.addSubview(self.contentView)
        self.contentView.addSubview(stackView)
        self.addSubview(descriptionLabel)
        self.addSubview(rulesPageButton)
        self.addSubview(retryButton)
    }
    
    func setupConstraints() {
        setupContentViewConstraints()
        setupStackViewConstraints()
        setupDescriptionLabelConstraints()
        setupRulesPageButttonConstraints()
        setupRulesPageButttonConstraints()
        setupRetryButttonConstraints()
    }
    
    func setupAdditionalConfiguration() {
        addLightsToStackView()
        // Gesture on lights' stack view
        stackView.addGestureRecognizer(stackViewTapGesture)
    }
    
    
    // MARK: Setup Constraints Functions
    
    // Content View
    private func setupContentViewConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.width.equalTo(self.singleLightHeight + 50 + 50)
            make.height.equalTo(self.stackViewHeight + 20 + 20)
            make.centerX.equalToSuperview()
        }
    }
    // Stack View
    private func setupStackViewConstraints() {
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(self.singleLightHeight)
            make.height.equalTo(self.stackViewHeight)
            make.centerX.equalToSuperview()
        }
    }
    // Description Label
    private func setupDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.bottom).offset(20)
//            make.left.equalToSuperview().offset(30)
//            make.right.equalToSuperview().offset(-30)
            make.centerX.equalTo(contentView.snp.centerX)
            make.height.equalTo(100)
        }
    }
    // Rules Page Button
    private func setupRulesPageButttonConstraints() {
        rulesPageButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
//            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    // Retry Buttton
    private func setupRetryButttonConstraints() {
        retryButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // MARK: Additional Configuration Functions
    
    private func addLightsToStackView(){
        let lights = lightManager.lights
        for light in lights {
            stackView.addArrangedSubview(light.circleView)
        }
    }
}
