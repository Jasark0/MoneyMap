//
//  LoadingOverlay.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 12/1/25.
//

import SwiftUI

struct LoadingOverlay: View {
    var message: String = "Loading..."

    var body: some View {
        ZStack {
            Color.black.opacity(0.15)
                .ignoresSafeArea()

            VStack(spacing: 12) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.4)
                    .tint(.gray)

                Text(message)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
        }
    }
}


