//
//  ExpenditurePickerView.swift
//  MoneyMap
//
//  Created by user279040 on 10/21/25.
//

import SwiftUI

struct ExpenditurePickerView: View {
    let title: String
    let options: [String]
    @Binding var selection: String?

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .foregroundColor(.gray)
                .fontWeight(.semibold)

            // Dropdown button
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selection ?? "Select an option")
                        .foregroundColor(selection == nil ? .gray : .black)
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(height: 50)
                .background(Color(.systemGray5))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Space Cadet").opacity(0.3), lineWidth: 1)
                )
            }

            // Dropdown list
            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            selection = option
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(option)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding()
                            .background(Color.white)
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color(.systemGray5)),
                            alignment: .bottom
                        )
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
        }
        .animation(.easeInOut, value: isExpanded)
    }
}

// Preview
struct ExpenditurePickerView_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var selectedType: String? = nil

        var body: some View {
            VStack(spacing: 20) {
                ExpenditurePickerView(
                    title: "Type of expenditure",
                    options: ["Needs", "Wants", "Savings"],
                    selection: $selectedType
                )
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}
