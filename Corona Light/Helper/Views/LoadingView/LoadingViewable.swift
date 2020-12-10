//
//  LoadingViewable.swift
//  MVVMRx
//
//  Created by iMamad on 7/26/18.
//  Copyright © 2018 Storm. All rights reserved.
//

import UIKit
import JGProgressHUD

protocol LoadingViewable {
    func startAnimating()
    func stopAnimating()
}
extension LoadingViewable where Self : UIViewController {
    func startAnimating(){
        let hud = JGProgressHUD()
        hud.textLabel.text = "Connecting to server..."
        hud.show(in: self.view)
        hud.restorationIdentifier = "loadingView"
        
        view.addSubview(hud)
    }
    func stopAnimating() {
        for item in view.subviews
            where item.restorationIdentifier == "loadingView" {
                UIView.animate(withDuration: 0.3, animations: {
                    item.alpha = 0
                }) { (_) in
                    item.removeFromSuperview()
                }
        }
    }
}
