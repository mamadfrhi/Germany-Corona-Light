//
//  LightVC.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit
import RxSwift
import RxCocoa

class LightVC: UIViewController {
    
    //MARK: Dependencies
    private var trafficLightView: TrafficLightView
    private var viewModel: LightViewModel
    
    //MARK: LifeCycle
    init(viewModel: LightViewModel,
         trafficLightView: TrafficLightView) {
        self.viewModel = viewModel
        self.trafficLightView = trafficLightView
        super.init(nibName: nil, bundle: nil)
        setupBindings()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = trafficLightView
    }
    
    //MARK: RX
    let disposeBag = DisposeBag()
    private func setupBindings() {
        // loading
        viewModel.loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
        // error
        viewModel
            .errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe { (message) in
                self.trafficLightView.currentOnlineLight = .off
                guard let message = message.element else { return}
                MessageView.sharedInstance.showOnView(message: message,
                                                      theme: .error)
            }
            .disposed(by: disposeBag)
        
        // incidents (Main Purpose)
        viewModel
            .stateStatus
            .observeOn(MainScheduler.instance)
            .subscribe { (statusColor) in
                self.trafficLightView.currentOnlineLight = statusColor
            }
            .disposed(by: disposeBag)
    }
}
