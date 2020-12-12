//
//  RulesView.swift
//  Corona Light
//
//  Created by iMamad on 12/8/20.
//

import UIKit
import SnapKit

internal
class RulesView : UIView {
    
    // MARK: Views
    private let myMaskView = MaskView(statusColor: .green)

    let statusLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "statusLabel".localized()
        lbl.numberOfLines = 2
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    let rulesTextView : UITextView = {
        let txtView = UITextView()
        txtView.text = "redStatusRules".localized()
        txtView.textAlignment = .justified
        txtView.font = UIFont.italicSystemFont(ofSize: 18)
        return txtView
    }()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        // Template methode
        self.setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Functions
    func set(statusColor: StatusColors) {
        myMaskView.setColor(statusColor: statusColor)
    }
}

// MARK:-
// MARK: Template Functions
// MARK:-
extension RulesView : CodeView {
    
    func buildViewHierachy() {
        self.addSubview(myMaskView)
        self.addSubview(statusLabel)
        self.addSubview(rulesTextView)
    }
    
    func setupConstraints() {
        setupMaskViewConstraints()
        addInfoLabelConstraints()
        addTextViewConstraints()
    }
}

// MARK:-
// MARK: Setup Constraints Functions
// MARK:-
extension RulesView {
    
    // Mask View
    private func setupMaskViewConstraints() {
        myMaskView.snp.makeConstraints { (make) in
            let viewWidth = screenBounds.size.width * 0.3
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(30)
            make.size.equalTo(viewWidth)
            make.centerX.equalToSuperview()
        }
    }
    
    // Info Label
    private func addInfoLabelConstraints() {
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(myMaskView.snp.bottom).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    // Rules Text View
    private func addTextViewConstraints() {
        rulesTextView.snp.makeConstraints { (make) in
            make.top.equalTo(statusLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
    
