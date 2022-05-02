//
//  NotificationManager.swift
//  Corona Light
//
//  Created by iMamad on 12/4/20.
//

import NotificationCenter
import RxSwift


// MARK:- Interface
protocol Notificationable {
    func requestNotificationPermission()
    func sendLocalizedNotification(at timetInterval: TimeInterval)
}

// MARK: - NotificationManager
class NotificationManager: NSObject {
    
    private let center = UNUserNotificationCenter.current()
    private let disposeable = DisposeBag()
    let notificationTapped: PublishSubject<Bool> = PublishSubject()
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        center.delegate = self
    }
    
    private var localizedNotification: Notification {
        get {
            let title = "notificationTitle".localized()
            let body = "notificationBody".localized()
            let notification = Notification(title: title,
                                            body: body)
            return notification
        }
    }
}

// MARK: - NotificationCenter Delegate
extension NotificationManager: UNUserNotificationCenterDelegate {
    // User tapped the banner or notification's category
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification button or banner tapped.\n")
        notificationTapped.onNext(true)
        completionHandler()
    }
    
    // To activate receiving notification on foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Push notification received in foreground.")
        if #available(iOS 14.0, *) {
            completionHandler([.sound, .banner])
        }
    }
}

// MARK: Notificationable implementation
extension NotificationManager: Notificationable {
    // Interface functions
    func requestNotificationPermission() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound]) {
                (granted, error) in
                if granted {
                    print("Notifications permission granted.")
                } else {
                    print("Notifications permission denied because: \(String(describing: error?.localizedDescription)).")
                }
            }
    }
    
    func sendLocalizedNotification(at timetInterval: TimeInterval) {
        registerCategories()
        let content = makeContent(from: localizedNotification)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timetInterval,
                                                        repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content, trigger: trigger)
        center.add(request)
    }
    
    // private functions
    private func makeContent(from notification: Notification) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "alarm"
        content.title = notification.title
        content.body = notification.body
        return content
    }
    private func registerCategories() {
        let notificationButtonText = "notificationButtonText".localized()
        let show = UNNotificationAction(identifier: "show",
                                        title: notificationButtonText,
                                        options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm",
                                              actions: [show],
                                              intentIdentifiers: [])
        center.setNotificationCategories([category])
    }
}
