//
//  Corona_LightTests.swift
//  Corona LightTests
//
//  Created by iMamad on 11.05.22.
//

import XCTest
@testable import Corona_Light
import RxTest
import RxSwift

class LightsVM_Tests: XCTestCase {
    
    let api = CoronaAPI()
    var coronaNetworking: CoronaNetworking?
    var locationManager: LocationManager?
    var notificationManager: NotificationManager?
    var SUT: LightsVM?
    
    var disposeBag: DisposeBag?
    var scheduler: Any?
    
    override func setUp() {
        super.setUp()
        coronaNetworking = CoronaNetworking(coronaAPI: api)
        locationManager = LocationManager()
        notificationManager = NotificationManager()
        SUT = LightsVM(mainCoordinatorDelegate: MainCoordinator(navigationController: UINavigationController()),
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
        XCTAssertNotNil(SUT, "SUT=LightsVM must not be nil")
    }
    
    func testLoading() {
        
    }
    
}
