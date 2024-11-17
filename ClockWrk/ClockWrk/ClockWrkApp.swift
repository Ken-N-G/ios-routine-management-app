//
//  ClockWrkApp.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 19/12/2022.
//

import SwiftUI
import Firebase

@main
struct ClockWrkApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let authVM = AuthVM()
            OnboardView()
                .environmentObject(authVM)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
