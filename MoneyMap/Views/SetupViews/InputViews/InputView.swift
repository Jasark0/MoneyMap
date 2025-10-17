//
//  InputView.swift
//  MoneyMap
//
//  Created by user279040 on 10/7/25.
//

import SwiftUI

struct InputView: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        TextField(title, text: $text)
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Space Cadet").opacity(0.3), lineWidth: 1)
            )
            .autocapitalization(.none)
    }
}
