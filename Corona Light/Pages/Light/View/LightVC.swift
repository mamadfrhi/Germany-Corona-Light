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
    private var coordinator: MainCoordinator
    
    //MARK: LifeCycle
    init(viewModel: LightViewModel,
         coordinator: MainCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        self.trafficLightView = TrafficLightView(frame: screenBounds)
        super.init(nibName: nil, bundle: nil)
        setupBindings()
        setupErrorBindings()
        setupNavigationBindings()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = trafficLightView
        self.title = "Corona Status"
    }
    
    private func pushRulesPage() {
        if self.currentStatus != .off {
            coordinator.pushRulesPage(for: self.currentStatus)
        }
    }
    
    //MARK: Variable
    private var currentStatus: LightColors = .off
    // RX
    private let disposeBag = DisposeBag()
    // Bindings
    private func setupBindings() {
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
            .observeOn(MainScheduler.instance)
            .subscribe { (statusColor) in
                guard let statusColorElement = statusColor.element else { return}
                self.trafficLightView.currentOnlineLight = statusColorElement
                self.trafficLightView.descriptionLabel.isHidden = false
                self.trafficLightView.rulesPageButton.isHidden = false
                self.trafficLightView.retryButton.isHidden = true
                self.currentStatus = statusColorElement
            }
            .disposed(by: disposeBag)
        
        // Location Info
        viewModel
            .locationInfo
            .observeOn(MainScheduler.instance)
            .subscribe { (locationInfo) in
                var descriptionLabelText = ""
                guard let locationInfo = locationInfo.element else {
                    return
                }
                descriptionLabelText = ""
                descriptionLabelText.append("📍 You're at\n")
                descriptionLabelText.append("\t\(locationInfo.country ?? "")\n")
                descriptionLabelText.append("\t\(locationInfo.state ?? "")\n")
                descriptionLabelText.append("\t\(locationInfo.town ?? "")")
                self.trafficLightView.descriptionLabel.text = descriptionLabelText
            }
            .disposed(by: disposeBag)
        
        // Retry Button
        trafficLightView.retryButton
            .rx.tap
            .subscribe { _ in
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
            .observeOn(MainScheduler.instance)
            .subscribe { (locationError) in
                self.handle(locationError: locationError)
            }
            .disposed(by: disposeBag)
        
        // Network Error
        viewModel
            .networkError
            .observeOn(MainScheduler.instance)
            .subscribe { (networkError) in
                self.trafficLightView.rulesPageButton.isHidden = true
                self.trafficLightView.retryButton.isHidden = false
                if self.currentStatus == .off,
                   // It remains previous state
                   // if now a network error occured
                   let networkError = networkError.element {
                    self.handle(networkError: networkError)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setupNavigationBindings() {
        
        // Light View Tap Gesture
        // Tap gesture added on contentView & stackView
        trafficLightView.stackViewTapGesture
            .rx
            .event
            .bind { (event) in
                print("LightView Tapped!")
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
        
        // Rules Page Button
        trafficLightView.rulesPageButton
            .rx.tap
            .subscribe { (tapped) in
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
        
        // MARK: Navigation
        // Notification Tapped
        viewModel
            .notificationTapped
            .observeOn(MainScheduler.instance)
            .subscribe { (event) in
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
    }
}

// MARK:- State Handler
// TODO: Clean it with State Design Pattern
// Detected states:
// Location Error State - Network Error State- Normal State
// Detected Variabels:
// descriptionLabel.isHidden - rulesButton.isHidden - message - status
extension LightVC {
    // Location Error Handling
    private func handle(locationError: LocationError) {
        let localizedErrorMessage = locationError.errorDescription
            ?? "An error releated to location services occured!"
        
        // Show Error Messsage to user
        switch locationError {
        case .locationNotAllowedError:
            // Show modal message
            // It's serious problem
            Toast.shared.showModal(description: localizedErrorMessage)
            
        case .outOfBavariaError, .badLocationError:
            // Show simple message view
            Toast.shared.showIn(body: localizedErrorMessage)
        }
        
        // Handle Views
        self.trafficLightView.currentOnlineLight = .off
        self.trafficLightView.descriptionLabel.text = localizedErrorMessage
        // Buttons
        self.trafficLightView.rulesPageButton.isHidden = true
        self.trafficLightView.retryButton.isHidden = false
    }
    
    // Network Error Handling
    private func handle(networkError: NetworkError) {
        let localizedErrorMessage =
            networkError.errorDescription
            ?? "An error releated to location services occured!"
        
        switch networkError {
        case .requestError:
            Toast.shared.showIn(body: localizedErrorMessage)
            
        case .serverDataError:
            Toast.shared.showIn(body: localizedErrorMessage)
        }
        
        self.trafficLightView.currentOnlineLight = .off
        self.trafficLightView.rulesPageButton.isHidden = true
        self.trafficLightView.retryButton.isHidden = false
    }
}
