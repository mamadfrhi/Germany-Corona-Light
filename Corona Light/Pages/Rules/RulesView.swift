//
//  RulesView.swift
//  Corona Light
//
//  Created by iMamad on 12/8/20.
//

import UIKit
import SnapKit

class RulesView: UIView {
    
    // MARK: Views
    let statusLight = CircleView(color: .darkGray)
    
    let statusLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = NSLocalizedString("statusLabel",
                                     comment: "statusLabel text")
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    let rulesTextView : UITextView = {
        let txtView = UITextView()
        txtView.text = NSLocalizedString("redStatusRules",
                                     comment: "statusLabel text")
        txtView.textAlignment = .justified
        txtView.font = UIFont.italicSystemFont(ofSize: 18)
        return txtView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupStatusView()
        setupInfoLabel()
        setupRulesTextView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RulesView {
    // MARK: Setup
    // Status View
    private func setupStatusView() {
        self.addSubview(statusLight)
        addStatusViewConstraints()
    }
    private func addStatusViewConstraints() {
        let circleViewWidths = UIScreen.main.bounds.size.width * 0.3
        statusLight.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.size.equalTo(circleViewWidths)
            make.centerX.equalToSuperview()
        }
    }
    
    // Info Label
    private func setupInfoLabel() {
        self.addSubview(statusLabel)
        addInfoLabelConstraints()
    }
    private func addInfoLabelConstraints() {
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(statusLight.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    // Rules Text View
    private func setupRulesTextView() {
        self.addSubview(rulesTextView)
        addTextViewConstraints()
    }
    private func addTextViewConstraints() {
        rulesTextView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
}
