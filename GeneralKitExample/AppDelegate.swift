//
//  AppDelegate.swift
//  GeneralKitExample
//
//  Created by Salah on 10/19/20.
//  Copyright © 2020 Salah. All rights reserved.
//

extension String{
    func bs_replace(target: String, withString: String) -> String{
        return self.replacingOccurrences(of: target, with:withString, options: .literal, range: nil)
    }
}
public extension Dictionary {
mutating func bs_merge(dict: [Key: Value]){
    for (k, v) in dict {
        updateValue(v, forKey: k)
    }
}
}
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public static var delegate:AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate;
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
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
    func exit(){
        
    }

}

