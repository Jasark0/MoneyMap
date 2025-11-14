import SwiftUI
import Combine

struct InputView: View {
    let title: String
    var placeholder: String? = nil
    @Binding var text: String
    @State private var hasPreFilled = false
    
    var body: some View {
        VStack {
            TextField(
                "",
                text: $text,
                prompt: (text.isEmpty && !hasPreFilled) ? Text(title).foregroundColor(.gray.opacity(0.6)) : nil
            )
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Space Cadet").opacity(0.3), lineWidth: 1)
            )
            .autocapitalization(.none)
        }
        .onAppear {
            if let placeholder = placeholder, text.isEmpty, !hasPreFilled {
                text = placeholder
                hasPreFilled = true
            }
        }
        .onChange(of: text) { oldValue, newValue in
            if newValue.isEmpty {
                hasPreFilled = false
            }
        }
    }
}
