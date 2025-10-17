//
//  SetupInputView.swift
//  MoneyMap
//
//  Created by user279040 on 10/9/25.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct SetupInputView: View {
    let title: String
    let placeHolder: String
    @Binding var number: Double

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.gray)
                .background(Color.white)

            HStack(spacing: 0) {
                Text(placeHolder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 20)
                    .background(Color.white)
                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])

                TextField("", value: $number, format: .number)
                    .keyboardType(.decimalPad)
                    .onChange(of: number) {
                        if number < 0 {
                            number = 0
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
            }
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Space Cadet").opacity(0.3), lineWidth: 1)
            )
        }
    }
}



