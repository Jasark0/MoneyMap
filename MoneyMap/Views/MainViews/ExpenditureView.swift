import SwiftUI
import Supabase

struct ExpenditureInsert: Encodable {
    let id: UUID
    let title: String
    let cost: Double
    let description: String?
}

struct ExpenditureView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var selectedType: String? = nil
    @State private var title: String = ""
    @State private var amount: Double = 0
    @State private var description: String = ""
    
    @State private var errorMessage: String? = nil
    
    @State private var navigateToMain = false
    
    let expenditureTypes = ["Needs", "Wants", "Savings"]
    
    private func addExpenditure() async -> Bool {
        guard let userId = sessionManager.userId else {
            print("No userId found")
            return false
        }

        guard let selectedType = selectedType else {
            errorMessage = "Select an expenditure type!"
            return false
        }
        
        guard !title.isEmpty else {
            errorMessage = "Input an expenditure title!"
            return false
        }

        let payload = ExpenditureInsert(
            id: userId,
            title: title,
            cost: amount,
            description: description.isEmpty ? nil : description
        )

        do {
            switch selectedType {
            case "Needs":
                try await supabase
                    .from("needs")
                    .insert(payload)
                    .execute()

            case "Wants":
                try await supabase
                    .from("wants")
                    .insert(payload)
                    .execute()

            case "Savings":
                try await supabase
                    .from("savings")
                    .insert(payload)
                    .execute()

            default:
                return false
            }

            return true

        } catch {
            errorMessage = "Missing fields!"
            return false
        }
    }

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 8) {
                    Text("Add an expenditure")
                        .font(.system(size: 28))
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                    
                    VStack(spacing: 20) {
                        ExpenditurePickerView(
                            title: "Type of expenditure",
                            options: expenditureTypes,
                            selection: $selectedType
                        )
                        
                        VStack(alignment: .leading) {
                            Text("Title")
                                .foregroundColor(.gray)
                                .fontWeight(.semibold)
                            
                            InputView(title: "Title", text: $title)
                        }
                        
                        SetupInputView(title: "Amount", placeHolder: "$", number: $amount)
                        
                        VStack(alignment: .leading) {
                            Text("Description (optional)")
                                .fontWeight(.semibold)
                            
                            TextEditor(text: $description)
                                .frame(height: 180)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 5)
                    }
                    
                    Button(action: {
                        Task {
                            if await addExpenditure() {
                                await sessionManager.fetchAllExpenditures()
                                navigateToMain = true
                            }
                        }
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

