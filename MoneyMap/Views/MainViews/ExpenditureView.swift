import SwiftUI

struct ExpenditureView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var selectedType: String? = nil
    @State private var amount: Double = 0
    @State private var description: String = ""
    
    @State private var navigateToMain = false
    
    let expenditureTypes = ["Needs", "Wants", "Savings"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    
                    Text("Add an expenditure")
                        .font(.system(size: 28))
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 25) {
                        ExpenditurePickerView(
                            title: "Type of expenditure",
                            options: expenditureTypes,
                            selection: $selectedType
                        )

                        SetupInputView(title: "Amount", placeHolder: "$", number: $amount)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Description (optional)")
                                .fontWeight(.semibold)
                            
                            TextEditor(text: $description)
                                .frame(height: 210)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {
                        navigateToMain = true
                    }) {
                        Text("Finish")
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
    }
}

#Preview {
    NavigationStack {
        ExpenditureView()
    }
    .environmentObject(SessionManager.preview)
}

