//
//  AppDelegate.swift
//  Win iOS
//
//  Created by BALARAM SOMINENI on 07/01/20.
//  Copyright © 2020 BALARAM SOMINENI. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import Firebase
import UserNotifications



var updateAppLink = true
var openedNotification = false



@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, customViewDelegate {
    
    var window: UIWindow?
    var customsView = CustomView()
    let gcmMessageIDKey = "gcm.message_id"
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UserDefaults.standard.removeObject(forKey: UserDefaultsStored.tokenID)
        let userdefaults = UserDefaults.standard
        if let savedValue = userdefaults.string(forKey: "userLoggedIn"){
            UserDefaults.standard.set(savedValue, forKey: UserDefaultsStored.emailID)
            UserDefaults.standard.set(true, forKey: UserDefaultsStored.UserLogedInOrNot)
            userdefaults.removeObject(forKey: "userLoggedIn")
           print("Here you will get saved value \(savedValue)")
        } else {
           print("No value in Userdefault,Either you can save value here or perform other operation")
           //userdefaults.set("Here you can save value", forKey: "key")
        }
        if let savedValue = userdefaults.string(forKey: "pass"){
            UserDefaults.standard.set(savedValue, forKey: UserDefaultsStored.password)
            UserDefaults.standard.set(true, forKey: UserDefaultsStored.UserLogedInOrNot)
            userdefaults.removeObject(forKey: "pass")
           print("Here you will get saved value \(savedValue)")
        } else {
           print("No value in Userdefault,Either you can save value here or perform other operation")
           //userdefaults.set("Here you can save value", forKey: "key")
        }
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyBes9Up_aPWaWsWh43jlMBPHf0CWIgTI9k")
        FirebaseApp.configure()
       if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert, .sound]) {
                (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                        //UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    //print("APNS Registration failed")
                    //print("Error: \(String(describing: error?.localizedDescription))")
                }
            }
        } else {
            let type: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
            let setting = UIUserNotificationSettings(types: type, categories: nil)
            application.registerUserNotificationSettings(setting)
            application.registerForRemoteNotifications()
            //UIApplication.shared.registerForRemoteNotifications()
        }
        UIApplication.shared.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        
        return true
    }
    func cancelBtnAction(sender: AnyObject) {
        print("Cancel Clicked")
    }
    
    func okayBtnAction(sender: AnyObject) {
        print("Okay Clicked")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Unable to register for remote notifications: \(error.localizedDescription)")
//    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        let userInfo = notification.request.content.userInfo
        if let aps = userInfo["aps"] as? NSDictionary {
            if let alert = aps["alert"] as? NSDictionary {
                if let message = alert["body"] as? NSString {
                    //Do stuff
                    
                    print(notification.request.content.userInfo)
                    self.customsView.loadingData(titleLabl: "\(String(describing: alert["title"] as! NSString))", subTitleLabel: "\(message)", cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
                    self.window?.addSubview(customsView)
                }
            } else if let alert = aps["alert"] as? NSString {
                //Do stuff
                print(alert)
            }
        }
        
        if notification.request.identifier == "rig"{
            completionHandler( [.alert,.sound,.badge])
        }else{
            completionHandler([.alert, .badge, .sound])
        }
    }
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //Handle the notification
        completionHandler(
            [UNNotificationPresentationOptions.alert,
             UNNotificationPresentationOptions.sound,
             UNNotificationPresentationOptions.badge])
    }
    private func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
        print("Registered Notification")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

            print(error.localizedDescription)
            print("Not registered notification")
    }
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//            }
//        let token = tokenParts.joined()
//
//        print("Token\(token)")
//    }
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
//        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print("this will return '32 bytes' in iOS 13+ rather than the token \(tokenString)")
//
//        Messaging.messaging().apnsToken = deviceToken
//        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//        print(deviceTokenString)
//    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if (UserDefaults.standard.object(forKey: UserDefaultsStored.UserLogedInOrNot) as? String) != nil {
            openedNotification = true
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let nav = UINavigationController(rootViewController: homeViewController)
            nav.navigationBar.isHidden = true
            appdelegate.window!.rootViewController = nav
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print(userInfo)
        switch application.applicationState {
        case .active:
            let content = UNMutableNotificationContent()
            if let title = userInfo["title"]
            {
                content.title = title as! String
            }
            if let title = userInfo["text"]
            {
                content.body = title as! String
            }
            content.userInfo = userInfo
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 0.5, repeats: false)
            let request = UNNotificationRequest(identifier:"rig", content: content, trigger: trigger)
            self.customsView.loadingData(titleLabl: content.title, subTitleLabel: content.body, cancelBtnTitle: "Cancel", okayBtnTitle: "Okay")
            self.window?.addSubview(customsView)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().add(request) { (error) in
                if let getError = error {
                    print(getError.localizedDescription)
                }
            }
        case .inactive:
            break
        case .background:
            break
        default:
            print("Empty")
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Message Data", remoteMessage.appData)
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

