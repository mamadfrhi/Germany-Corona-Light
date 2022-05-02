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
    private var viewModel: LightsViewModel
    
    //MARK: - States
    private var locationErrorStateable: LocationErrorStateable?
    private var networkErrorStateable: NetworkErrorStateable?
    private var normalStateable: NormalStateable?
    
    
    //MARK: - Lifecycle
    init(viewModel: LightsViewModel) {
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
    
    private func pushRulesPage() {
        if self.currentStatus != .off {
            viewModel.didSelect(statusColor: self.currentStatus)
        }
    }
    
    
    //MARK: - Variable
    private let currentStatus: StatusColors = .off
    private let disposeBag = DisposeBag()
}

//MARK: RX Binding
extension LightsVC {
    private func setupVC() {
        setupStates()
        setupGeneralBindings()
        setupErrorBindings()
        setupNavigationBindings()
    }
    
    // Bindings
    private func setupGeneralBindings() {
        
        
        // Loading
        viewModel.loading
            .bind(onNext: { (loading) in
                // Just show loading view for first request
                // prevent showing for next refreshal requests
                if self.currentStatus == .off {
                    self.rx.isAnimating.onNext(loading)
                }
            })
            .disposed(by: disposeBag)
        
        
        // Town Status (Main Purpose)
        viewModel
            .townStatus
            .observe(on: MainScheduler.instance)
            .subscribe { (statusColor) in
                guard let statusColorElement = statusColor.element
                else { return }
                self.lightsView.currentOnlineLight = statusColorElement
                self.currentStatus = statusColorElement
                self.setNormlaState()
            }
            .disposed(by: disposeBag)
        
        
        // Location Info
        viewModel
            .locationInfo
            .observe(on: MainScheduler.instance)
            .subscribe { (locationInfo) in
                var descriptionLabelText = ""
                guard let locationInfo = locationInfo.element else {
                    return
                }
                descriptionLabelText = ""
                descriptionLabelText.append("📍 ")
                let youAreAt = "youAreAt".localized() + "\n"
                descriptionLabelText.append(youAreAt)
                descriptionLabelText.append("\t\(locationInfo.country ?? "")\n")
                descriptionLabelText.append("\t\(locationInfo.state ?? "")\n")
                descriptionLabelText.append("\t\(locationInfo.town ?? "")")
                self.lightsView.changeDesciriptionLabel(text: descriptionLabelText)
            }
            .disposed(by: disposeBag)
        
        
        // Retry Button
        lightsView.retryButton
            .rx.tap
            .subscribe { _ in
                // Trig locaiton manager
                self.viewModel.startUpdatingLocation()
                // Fresh request
                self.viewModel.retryRequest()
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setupErrorBindings() {
        
        
        // Location Error
        viewModel
            .locationError
            .observe(on: MainScheduler.instance)
            .subscribe { (locationError) in
                self.setLocationErrorState(locationError: locationError)
            }
            .disposed(by: disposeBag)
        
        
        // Network Error
        viewModel
            .networkError
            .observe(on: MainScheduler.instance)
            .subscribe { (networkError) in
                
                // if recently a network error occured
                // It remains previous state
                if self.currentStatus == .off,
                   let networkError = networkError.element {
                    self.networkErrorStateable?
                        .setNewtorkErrorState(networkError: networkError)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBindings() {
        
        // Light View Tap Gesture
        // Tap gesture added on contentView & stackView
        lightsView.stackViewTapGesture
            .rx
            .event
            .bind { _ in
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
        
        
        // Rules Page Button
        lightsView.rulesPageButton
            .rx.tap
            .subscribe { _ in
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
        
        
        // Notification Tapped
        viewModel
            .notificationTapped
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
    }
}

// MARK:-
// MARK: States
// MARK:-

//MARK: State Setups
extension LightsVC {
    // It calls from init
    private func setupStates() {
        // States
        // Location Error State
        self.locationErrorStateable =
            LocationErrorState(lightsView: self.lightsView)
        
        // Network Error State
        self.networkErrorStateable =
            NewtorkErrorState(lightsView: self.lightsView)
        
        // Normal State
        self.normalStateable =
            NormalState(lightsView: self.lightsView)
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
    func setNewtorkErrorState(networkError: NetworkError) {
        self.networkErrorStateable?
            .setNewtorkErrorState(networkError: networkError)
    }
}

// Normal Stateable
extension LightsVC : NormalStateable {
    func setNormlaState() {
        self.normalStateable?
            .setNormlaState()
    }
}
