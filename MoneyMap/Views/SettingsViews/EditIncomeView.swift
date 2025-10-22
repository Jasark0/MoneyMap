import SwiftUI

struct EditIncomeView: View {
    @State private var income: Double = 0
    @State private var goal: Double = 0
    @State private var needs: Double = 50
    @State private var wants: Double = 30
    @State private var savings: Double = 20
    
    @State private var navigateToMain = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Edit Income")
                        .font(.system(size: 28))
                        .fontWeight(.bold)
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 25) {
                        SetupInputView(title: "Monthly Income", placeHolder: "$", number: $income)
                        SetupInputView(title: "Goal", placeHolder: "$", number: $goal)
                        SetupInputView(title: "Needs %", placeHolder: "%", number: $needs)
                        SetupInputView(title: "Wants %", placeHolder: "%", number: $wants)
                        SetupInputView(title: "Savings %", placeHolder: "%", number: $savings)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        navigateToMain = true
                    }) {
                        Text("Save")
                            .font(.system(size: 18))
                            .padding(.horizontal, 100)
                            .padding(.vertical, 20)
                            .foregroundColor(.white)
                            .background(Color("Oxford Blue"))
                            .cornerRadius(15)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .navigationDestination(isPresented: $navigateToMain) {
                    MainView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        EditIncomeView()
    }
}
