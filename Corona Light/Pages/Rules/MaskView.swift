//
//  MaskView.swift
//  Corona Light
//
//  Created by iMamad on 12/11/20.
//

import UIKit


// MARK: MaskView
class MaskView: UIView {
    
    // Variables
    private var statusColor: LightColors {
        willSet {
            self.statusColor = newValue
            self.statusLight.backgroundColor = UIColor(named: newValue.rawValue)
        }
    }
    private var statusLight : CircleView
    private let maskImage : UIImageView = {
        let image = UIImage(named: "mask")!
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        return imageView
    }()
    
    // Init
    init(statusColor: LightColors) {
        self.statusColor = statusColor
        let color = UIColor(named: statusColor.rawValue)!
        self.statusLight = CircleView(color: color)
        super.init(frame: .zero)
        
        setupStatusLight()
        setupMaskImage()
        animateMask()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function
    func setColor(statusColor: LightColors) {
        self.statusColor = statusColor
        animateStatusLight()
    }
}
// MARK: Setups
extension MaskView {
    // Status Light
    private func setupStatusLight() {
        self.addSubview(statusLight)
        statusLight.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    // Mask Image
    private func setupMaskImage() {
        self.addSubview(maskImage)
        maskImage.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
    }
}

// MARK: Animations
extension MaskView {
    private func animateMask() {
        UIView.animate(withDuration: 1.5) {
            self.maskImage.alpha = 1
            let transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.maskImage.transform = transform
        } completion: { _ in
            UIView.animate(withDuration: 3) {
                self.maskImage.transform = .identity
            }
        }
    }
    
    private func animateStatusLight() {
        if (self.statusColor == .darkRed) || (statusColor == .red) {
            self.statusLight.blink()
        }
    }
}
