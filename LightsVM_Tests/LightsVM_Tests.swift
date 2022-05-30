//
//  Corona_LightTests.swift
//  Corona LightTests
//
//  Created by iMamad on 11.05.22.
//

@testable import Corona_Light
import XCTest
import RxTest
import RxSwift

class LightsVM_Tests: XCTestCase {
    
    let api = CoronaAPI()
    var coronaNetworking: CoronaNetworking?
    var locationManager: LocationManager?
    var notificationManager: NotificationManager?
    var viewModel: LightsVM?
    
    var disposeBag: DisposeBag?
    var scheduler: TestScheduler?
    
    override func setUp() {
        super.setUp()
        coronaNetworking = CoronaNetworking(coronaAPI: api)
        locationManager = LocationManager()
        notificationManager = NotificationManager()
        viewModel = LightsVM(mainCoordinatorDelegate: MainCoordinator(navigationController: UINavigationController()),
                       coronaNetworking: coronaNetworking!,
                       locationManager: locationManager!,
                       notificationManager: notificationManager!)
        
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    func testCoronaNetworkingLayer() {
        let coronaNetworkingConformationCheck = (coronaNetworking.self as? CoronaNetworkable) != nil
        
        XCTAssertNotNil(coronaNetworking, "coronaNetworking must not be nil")
        XCTAssertTrue(coronaNetworkingConformationCheck, "coronaNetworking class must conform CoronaNetworkable protocol")
    }
    
    func testLocationManagerLayer() {
        let locationManagerConformationCheck = (locationManager as? Locationable) != nil
        
        XCTAssertNotNil(locationManagerConformationCheck, "locationManager must not be nil")
        XCTAssertTrue(locationManagerConformationCheck, "locationManager must conform Locationable protocol")
    }
    
    func testNotificationManagerLayer() {
        let locationManagerConformationCheck = (notificationManager as? Notificationable) != nil
        
        XCTAssertNotNil(locationManagerConformationCheck, "notificationManager must not be nil")
        XCTAssertTrue(locationManagerConformationCheck, "notificationManager must conform Notificationable protocol")
    }
    
    func testLightsVM() {
        XCTAssertNotNil(viewModel, "LightsVM must not be nil")
    }
    
    func testLoading() {
        let isLoading = scheduler!.createObserver(Bool.self)
        _ = viewModel!.loading.bind(to: isLoading)
            .disposed(by: disposeBag!)
        
        let currentTown = "Würzburg"
        viewModel?.getIncidents(of: currentTown)
            
        
        XCTAssertRecordedElements(isLoading.events, [true])
    }
    
}

// MARK: Status Colors
// based on incidences
extension LightsVM_Tests {
    
    func testGreenStatus() {
        let townStatus = scheduler!.createObserver(StatusColors.self)
        _ = viewModel!.townStatus.bind(to: townStatus)
            .disposed(by: disposeBag!)
        
        let greenIncidentsCount = 299
        viewModel!.didGet(incidents: greenIncidentsCount)
        
        XCTAssertRecordedElements(townStatus.events, [StatusColors.green])
    }
    
    func testYellowStatus() {
        let townStatus = scheduler!.createObserver(StatusColors.self)
        _ = viewModel!.townStatus.bind(to: townStatus)
            .disposed(by: disposeBag!)
        
        let yellowIncidentsCount = 300
        viewModel!.didGet(incidents: yellowIncidentsCount)
        
        XCTAssertRecordedElements(townStatus.events, [StatusColors.yellow])
    }
    
    func testRedStatus() {
        let townStatus = scheduler!.createObserver(StatusColors.self)
        _ = viewModel!.townStatus.bind(to: townStatus)
            .disposed(by: disposeBag!)
        
        let redIncidentsCount = 601
        viewModel!.didGet(incidents: redIncidentsCount)
        
        XCTAssertRecordedElements(townStatus.events, [StatusColors.red])
    }
    
    func testDarkRedStatus() {
        let townStatus = scheduler!.createObserver(StatusColors.self)
        _ = viewModel!.townStatus.bind(to: townStatus)
            .disposed(by: disposeBag!)
        
        let darkRedIncidentsCount = 1201
        viewModel!.didGet(incidents: darkRedIncidentsCount)
        
        XCTAssertRecordedElements(townStatus.events, [StatusColors.darkRed])
    }
}
