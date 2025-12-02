//
//  SplashScreen.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 12/1/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var showGetStarted = false
    @State private var logoOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            Image("MoneyMapLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 260, height: 260)
                .opacity(logoOpacity)
        }
        .onAppear {
            // Smooth fade-in
            withAnimation(.easeOut(duration: 1)) {
                logoOpacity = 1.0
            }
            
            // After a short delay, move to GetStarted
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                showGetStarted = true
            }
        }
        .fullScreenCover(isPresented: $showGetStarted) {
            GetStartedView()
                .environmentObject(sessionManager)
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(SessionManager.preview)
}
