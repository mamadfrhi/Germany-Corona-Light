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
        
        // error
        viewModel
            .errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe { (message) in
                self.trafficLightView.currentOnlineLight = .off
                guard let message = message.element else { return}
                Toast.shared.showIn(body: message)
            }
            .disposed(by: disposeBag)
        
        // location error
        viewModel
            .locationError
            .observeOn(MainScheduler.instance)
            .subscribe { (locationError) in
                guard let locationError = locationError.element else { return}
                Toast.shared.showModal(description: locationError.description)
                self.seriousError(occured: true)
            }
            .disposed(by: disposeBag)
        
        // townStatus (Main Purpose)
        viewModel
            .townStatus
            .observeOn(MainScheduler.instance)
            .subscribe { (statusColor) in
                guard let statusColorElement = statusColor.element else { return}
                self.trafficLightView.currentOnlineLight = statusColorElement
                self.currentStatus = statusColorElement
                self.seriousError(occured: false)
            }
            .disposed(by: disposeBag)
        
        // locationInfo
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
        // rulesPageButton
        trafficLightView.rulesPageButton
            .rx.tap
            .subscribe { (tapped) in
                self.pushRulesPage()
            }
            .disposed(by: disposeBag)
    }
    // TODO: ADD RETRY Button
    private func seriousError(occured: Bool) {
        self.trafficLightView.descriptionLabel.isHidden = occured
        self.trafficLightView.rulesPageButton.isHidden = occured
    }
}
