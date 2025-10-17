//
//  ContentView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var sessionManager = SessionManager()

    var body: some View {
        GetStartedView()
            .environmentObject(sessionManager)
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager.preview)
}

