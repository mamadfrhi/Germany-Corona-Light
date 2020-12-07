//
//  LightVC.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit
import SnapKit

class LightVC: UIViewController {
    
    //MARK: Dependencies
    private var trafficLightView: TrafficLightView
    var viewModel: LightViewModel
    
    //MARK: LifeCycle
    init(viewModel: LightViewModel,
         trafficLightView: TrafficLightView) {
        self.viewModel = viewModel
        self.trafficLightView = trafficLightView
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = trafficLightView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        trafficLightView.currentOnlineLight = .green
    }
}
