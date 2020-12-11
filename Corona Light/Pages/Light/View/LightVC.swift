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
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = trafficLightView
    }
    
    private func pushRulesPage() {
        if let statusColor = self.currentStatus {
            coordinator.pushRulesPage(for: statusColor)
        }
    }
    
    //MARK: Variable
    private var currentStatus: LightColors?
    // RX
    private let disposeBag = DisposeBag()
    private func setupBindings() {
        // MARK: Binding
        // loading
        viewModel.loading
            .bind(to: self.rx.isAnimating)
            .disposed(by: disposeBag)
        
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
                self.handle(networkError: networkError)
            }
            .disposed(by: disposeBag)
        
        // Town Status (Main Purpose)
        viewModel
            .townStatus
            .observeOn(MainScheduler.instance)
            .subscribe { (statusColor) in
                guard let statusColorElement = statusColor.element else { return}
                self.trafficLightView.currentOnlineLight = statusColorElement
                self.trafficLightView.descriptionLabel.isHidden = false
                self.currentStatus = statusColorElement
            }
            .disposed(by: disposeBag)
        
        // Location Info
        viewModel
            .locationInfo
            .observeOn(MainScheduler.instance)
            .subscribe { (locationInfo) in
                var descriptionLabelText = "📍 Location not detected yet"
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
        
        // MARK: Navigation
        // Notification Tapped
        viewModel
            .notificationTapped
            .observeOn(MainScheduler.instance)
            .subscribe { (event) in
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
    }
}

// MARK:- State Handler
// TODO: Clean it with State Design Pattern
// Detected states:
// Location Error State - Network Error State- Normal State
// Detected Variabels:
// descriptionLabel.isHidden - rulesButton.isHidden - message - status
extension LightVC {
    private func handle(locationError: LocationError) {
        let localizedErrorMessage = locationError.errorDescription
            ?? "An error releated to location services occured!"
        
        switch locationError {
        case .locationNotAllowedError:
            Toast.shared.showModal(description: localizedErrorMessage)
            self.trafficLightView.descriptionLabel.isHidden = true
        case .outOfBavariaError, .badLocationError:
            Toast.shared.showIn(body: localizedErrorMessage)
            self.trafficLightView.descriptionLabel.isHidden = false
            self.trafficLightView.descriptionLabel.text = localizedErrorMessage
        }
        self.trafficLightView.rulesPageButton.isHidden = true
    }
    
    private func handle(networkError: NetworkError) {
        let localizedErrorMessage = networkError.errorDescription
            ?? "An error releated to location services occured!"
        switch networkError {
        case .requestError:
            Toast.shared.showIn(body: localizedErrorMessage)
        case .serverDataError:
            Toast.shared.showIn(body: localizedErrorMessage)
        }
        self.trafficLightView.currentOnlineLight = .off
        self.trafficLightView.rulesPageButton.isHidden = true
    }
}
