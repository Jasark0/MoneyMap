//
//  MoneyMapApp.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI
import SwiftData
import Combine

@main
struct MoneyMapApp: App {
    @StateObject private var sessionManager = SessionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(sessionManager)
                .task {
                    if sessionManager.isLoggedIn {
                        await sessionManager.fetchProfile()
                    }
                }
        }
    }
}





