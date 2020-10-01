//
//  AppDelegate.swift
//  LocationTestApp
//
//  Created by Takahiro Kirifu on 2020/08/20.
//  Copyright © 2020 Takahiro Kirifu. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseCore
import FirebaseFirestore
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    var db: Firestore!
    
    
    var locationManager: CLLocationManager!
    var time: String?
    var longitude: String?
    var latitude: String?
    //var array = [[String]]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        // Firebaseの共有インスタインスの設定
        FirebaseApp.configure()
        
        // [START set_messaging_delegate]
        // CloudMessagingのデリゲートを設定
        Messaging.messaging().delegate = self
        // [END set_messaging_delegate]
        
        // [START default_firestore]
        //FirebaseApp.configure()

        setupFirestore()
        // [END default_firestore]
        
        UIApplication.shared.registerForRemoteNotifications()
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        // 通知の設定を行う
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        // [END register_for_notifications]
        
        return true
    }
    
    // 代行者に、アプリが無効になろうとしていることを伝えます。
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    // アプリがバックグラウンドになったことを委任者に伝えます。
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    // アプリがフォアグラウンドに入ろうとしていることを代表者に伝えます。
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    // アプリが非アクティブ状態からアクティブ状態に移行したことを通知します。
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    // アプリが終了しようとしているときにデリゲートに通知します。
    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print("didReceiveRemoteNotification")
        
        // Print full message.
        print(userInfo)
    }
    
    // 通知を受け取った場合
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        print("silent notification")
        print(#function)
        
        // stop -> start で位置情報更新させる
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        print("緯度：\(latitude!)")
        print("経度：\(longitude!)")
        print("時間：\(time!)")
        
        
        // stop -> start で位置情報更新させる
        
        // Add a new document
        var ref: DocumentReference? = nil
        
        ref = db.collection("location").addDocument(data: [
            "latitude": latitude!,
            "longitude": longitude!,
            "time": time!
        ]) { error in
            if let error = error {
                print("error adding document: \(error)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    
    func setupFirestore() {
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        
        db = Firestore.firestore()
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    // This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    // If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    // the FCM registration token.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Messaging.messaging().subscribe(toTopic: "ios") { error in
            print("Subscribed to ios topic")
        }
        
        print("APNs token retrieved: \(deviceToken)")
        
        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    // アプリ起動時に通知を受け取った時
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([[.alert, .sound]])
    }
    
    // 受け取った通知を開いた時 ユーザーが通知バナーをタップしたとき
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
}

// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": "ios"]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    // [END refresh_token]
}

extension AppDelegate : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 緯度経度
        let location = locations.first
        let latestLatitude = location?.coordinate.latitude
        let latestLongitude = location?.coordinate.longitude
        latitude = String(latestLatitude!)
        longitude = String(latestLongitude!)

        // 時間
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM-dd 'at' HH:mm", options: 0, locale: Locale(identifier: "ja_JP"))
        time = dateFormatter.string(from: date)
    }
}
