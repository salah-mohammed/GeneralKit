//
//  AppDelegate.swift
//  GeneralKitUIKitExample
//
//  Created by SalahMohamed on 17/10/2022.
//

import UIKit
import GeneralKit
import MBProgressHUD
//import NavigationKit
@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RequestBuilder.shared.waitingView { value in
            if value {
                print("loader loaded")
                DispatchQueue.main.async {
                    if let view:UIView = UIApplication.shared.bs_window?.rootViewController?.view{
                        MBProgressHUD.showAdded(to:view, animated: true);
                    }
                }
            }else{
                DispatchQueue.main.async {
                    if let view:UIView = UIApplication.shared.bs_window?.rootViewController?.view{
                        MBProgressHUD.hide(for:view, animated: true);
                    }
                }
                print("loader dismiss")
            }
        }
//        GeneralListConstant.global.loadingDataHandler = {
//            let view = ListPlaceHolderView.loadViewFromNib()
//            view.data=LoadingData
//            return view
//        }
//        GeneralListConstant.global.errorConnectionDataViewHandler = {
//            let view = ListPlaceHolderView.loadViewFromNib()
//            view.data=ErrorConnection
//            return view
//        }
//        GeneralListConstant.global.emptyDataViewHandler = {
//            let view = ListPlaceHolderView.loadViewFromNib()
//            view.data=EmptyData
//            return view
//        }
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


}


extension UIApplication{
    public var bs_window: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        }
   }
}


/*
 xcodebuild archive -scheme GeneralKit -destination="iOS" -archivePath /tmp/xcf/ios.xcarchive -derivedDataPath /tmp/iphoneos -sdk iphoneos SKIP_INSTALL=NO
   xcodebuild archive -scheme GeneralKit -destination="iOS Simulator" -archivePath /tmp/xcf/iossimulator.xcarchive -derivedDataPath /tmp/iphoneos -sdk iphonesimulator SKIP_INSTALL=NO
    xcodebuild -create-xcframework -framework /tmp/xcf/ios.xcarchive/Products/Library/Frameworks/GeneralKit.framework -framework /tmp/xcf/iossimulator.xcarchive/Products/Library/Frameworks/GeneralKit.framework -output GeneralKit.xcframework
 */
