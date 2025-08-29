//
//  GeneralKitExampleApp.swift
//  GeneralKitExample
//
//  Created by Salah on 9/24/22.
//

import SwiftUI
import GeneralKit
@main
struct GeneralKitExampleApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView().onAppear(){
                    RequestBuilder.shared.simulateLocalResponse = .combain
                }
                
            }
        }
    }
}
