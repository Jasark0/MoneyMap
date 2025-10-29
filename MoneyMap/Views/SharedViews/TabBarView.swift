//
//  TabBarView.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 10/17/25.
//

import SwiftUI

enum AppTab: Hashable { case home, budget, reports, settings }

extension AppTab {
    var title: String {
        switch self {
        case .home: return "Home"
        case .budget: return "Budget"
        case .reports: return "Reports"
        case .settings: return "Settings"
        }
    }
    var systemImage: String {
        switch self {
        case .home: return "house.fill"
        case .budget: return "circle.grid.3x3.fill"
        case .reports: return "doc.text.magnifyingglass"
        case .settings: return "gearshape.fill"
        }
    }
}

struct TabBarView: View {
    @Binding var selection: AppTab

    private let barHeight: CGFloat = 64
    private let cornerRadius: CGFloat = 22

    var body: some View {
        HStack(spacing: 0) {
            TabButton(tab: .home,    selection: $selection)
            TabButton(tab: .budget,  selection: $selection)
            TabButton(tab: .reports, selection: $selection)
            TabButton(tab: .settings,selection: $selection)
        }
        .frame(height: barHeight)
        .padding(.horizontal, 24)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(Color.white)
                .overlay(
                    VStack(spacing: 0) {
                        Color.black.opacity(0.06).frame(height: 0.5)
                        Spacer()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                )
        )
        .background(Color(.systemBackground).ignoresSafeArea(edges: .bottom))
    }
}

private struct TabButton: View {
    let tab: AppTab
    @Binding var selection: AppTab
    var isActive: Bool { selection == tab }

    var body: some View {
        Button {
            if selection != tab {
                selection = tab
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(isActive ? .navy : .tabGray)
                Text(tab.title)
                    .font(.system(size: 12, weight: isActive ? .semibold : .regular))
                    .foregroundColor(isActive ? .navy : .tabGray)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isActive ? .isSelected : [])
    }
}

private extension Color {
    static let navy    = Color(red: 18/255, green: 31/255, blue: 66/255)
    static let tabGray = Color.black.opacity(0.35)
}

#Preview {
    ZStack {
        Color(white: 0.98).ignoresSafeArea()
        VStack { Spacer() }
    }
    .safeAreaInset(edge: .bottom) {
        TabBarView(selection: .constant(.budget))
            .padding(.horizontal, 8)
            .padding(.bottom, 0)     // remove bottom padding
            .background(Color.white.ignoresSafeArea(edges: .bottom))
    }
}


