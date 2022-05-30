//
//  LightVC.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import UIKit
import RxSwift
import RxCocoa

class LightsVC : UIViewController {
    
    //MARK: Dependencies
    private var lightsView: LightsView
    private var viewModel: LightsVM
    
    //MARK: - States
    private var locationErrorStateable: LocationErrorStateable?
    private var networkErrorStateable: NetworkErrorStateable?
    private var normalStateable: NormalStateable?
    
    
    //MARK: - Lifecycle
    required init(viewModel: LightsVM) {
        self.viewModel = viewModel
        self.lightsView = LightsView(frame: screenBounds)
        super.init(nibName: nil, bundle: nil)
        self.setupVC()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = lightsView
        self.title = "coronaStatus".localized()
    }
    
    private func setupVC() {
        setupStates()
        setupGeneralBindings()
        setupErrorBindings()
        setupNavigationBindings()
    }
    
    private func pushRulesPage() {
        if self.currentStatus != .off {
            viewModel.didSelect(statusColor: self.currentStatus)
        }
    }
    
    
    //MARK: - Variable
    private var currentStatus: StatusColors = .off
    private let disposeBag = DisposeBag()
}

//MARK: State Setups
extension LightsVC {
    private func setupStates() {
        // Location Error State
        self.locationErrorStateable =
        LocationErrorState(lightsView: self.lightsView)
        
        // Network Error State
        self.networkErrorStateable =
        NetworkErrorState(lightsView: self.lightsView)
        
        // Normal State
        self.normalStateable =
        NormalState(lightsView: self.lightsView)
    }
}

//MARK: RX Binding
extension LightsVC {
    private func setupGeneralBindings() {
        // Loading
        viewModel.loading
            .bind(onNext: {
                // Just show loading view for first request
                // prevent showing for next refreshal requests
                if self.currentStatus == .off {
                    self.rx.isAnimating.onNext($0)
                }
            })
            .disposed(by: disposeBag)
        
        
        // Town Status
        viewModel
            .townStatus
            .observe(on: MainScheduler.instance)
            .subscribe {
                guard let statusColor = $0.element
                else { return }
                self.lightsView.currentOnlineLight = statusColor
                self.currentStatus = statusColor
                self.setNormlaState()
            }
            .disposed(by: disposeBag)
        
        
        // Location Info
        viewModel
            .locationInfo
            .observe(on: MainScheduler.instance)
            .subscribe {
                var descriptionLabelText = ""
                guard let locationInfo = $0.element else { return }
                descriptionLabelText = ""
                descriptionLabelText.append("📍 ")
                let youAreAt = "youAreAt".localized() + "\n"
                descriptionLabelText.append(youAreAt)
                descriptionLabelText.append("\t\(locationInfo.country ?? "")\n")
                descriptionLabelText.append("\t\(locationInfo.state ?? "")\n")
                descriptionLabelText.append("\t\(locationInfo.town ?? "")")
                self.lightsView.changeDescriptionLabel(text: descriptionLabelText)
            }
            .disposed(by: disposeBag)
        
        
        // Retry Button
        lightsView.retryButton
            .rx.tap
            .subscribe { _ in
                self.viewModel.startUpdatingLocation()
                self.viewModel.retryRequest()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupErrorBindings() {
        // Location Error
        viewModel
            .locationError
            .observe(on: MainScheduler.instance)
            .subscribe {
                self.setLocationErrorState(locationError: $0)
            }
            .disposed(by: disposeBag)
        
        // Network Error
        viewModel
            .networkError
            .observe(on: MainScheduler.instance)
            .subscribe {
                if let networkError = $0.element {
                    self.setNetworkErrorState(networkError: networkError)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBindings() {
        
        // Light View Tap Gesture
        lightsView.stackViewTapGesture
            .rx.event
            .bind { _ in self.pushRulesPage() }
            .disposed(by: disposeBag)
        
        // Rules Page Button
        lightsView.rulesPageButton
            .rx.tap
            .subscribe { _ in self.pushRulesPage() }
            .disposed(by: disposeBag)
        
        
        // Notification Tapped
        viewModel
            .notificationTapped
            .observe(on: MainScheduler.instance)
            .subscribe { _ in self.pushRulesPage() }
            .disposed(by: disposeBag)
    }
}



//MARK: State Setters
// Location Error Stateable
extension LightsVC : LocationErrorStateable {
    func setLocationErrorState(locationError: LocationError) {
        self.locationErrorStateable?
            .setLocationErrorState(locationError: locationError)
    }
}

// Network Error Stateable
extension LightsVC : NetworkErrorStateable {
    func setNetworkErrorState(networkError: NetworkError) {
        self.networkErrorStateable?
            .setNetworkErrorState(networkError: networkError)
    }
}

// Normal Stateable
extension LightsVC : NormalStateable {
    func setNormlaState() {
        self.normalStateable?
            .setNormlaState()
    }
}
