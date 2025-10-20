//
//  MainShellView.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 10/19/25.
//

import SwiftUI

struct MainShellView: View {
    @State private var selection: AppTab = .home
    private let reservedBottomSpace: CGFloat = 72
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemBackground).ignoresSafeArea()
            
            // Main content fills the screen
            contentView(for: selection)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: reservedBottomSpace)
        }
        .overlay(alignment: .bottom) {
            TabBarView(selection: $selection)
                .padding(.horizontal, 1)
                .padding(.bottom, 0)
                .ignoresSafeArea(.container, edges: .bottom)
                .offset(y: 20)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    @ViewBuilder
    private func contentView(for tab: AppTab) -> some View {
        switch tab {
        case .home:
            NavigationStack {
                MainView()
                    .navigationTitle("Home")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        case .budget:
            NavigationStack{
                BudgetView()
                    .toolbar(.hidden, for: .navigationBar)
            }            
            
        case .reports:
            NavigationStack {
                ReportView()
                    .navigationTitle("Reports")
                    .navigationBarTitleDisplayMode(.inline)
            }
            
        case .settings:
            NavigationStack {
                SettingsView()
                    .navigationTitle("Settings")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}


#Preview { MainShellView() }

