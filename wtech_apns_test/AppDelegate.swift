//
//  AppDelegate.swift
//  wtech_apns_test
//
//  Created by sangchul on 28/05/2019.
//  Copyright © 2019 sangchul. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerApns()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = ((deviceToken as NSData).description.trimmingCharacters(in: CharacterSet(charactersIn: "<>")) as NSString).replacingOccurrences(of: " ", with: "")
        
        // UIApplication.shared.keyWindow : 앱의 가장 기본 바닥에 깔리는 윈도우입니다.
        // rootViewController: keyWindow에 기본이 되는 UIViewController를 하나 올리는데 그걸 rootViewControlller입니다.
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            
            // presentedViewController: rootViewController위에 떠있는 컨트롤러 중 현재 제일 위에 떠있는 컨트롤러에요.
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            // 현재 제일위에 떠있는 컨트롤러가 ViewController 타입이라면,,,,
            if ((topController as? ViewController) != nil) {
                // 여기서 띄우면 돼요.
                
                topController.present(UIAlertController(title: "deviceToken", message: "\(deviceTokenString)", preferredStyle: UIAlertController.Style.alert), animated: true, completion: nil)
                
            }
            
            
        }
        
        print("success apns register: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("fail apns register: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("foreground User Info = \(notification.request.content.userInfo)")
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("background User Info = \(response.notification.request.content.userInfo)")
        completionHandler()
    }

    func registerApns() {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge], completionHandler: {
                (grandted, error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    else
                    {
                        print("requestAuthorization Error: \(error.debugDescription)")
                    }
                })
        }
    }

}

