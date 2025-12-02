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
    @State private var isLoading = false

    
    private enum ExpenditureWarning: Identifiable {
        case overspend
        case goal
        
        var id: Int {
            switch self {
            case .overspend: return 0
            case .goal:      return 1
            }
        }
    }
    
    @State private var activeWarning: ExpenditureWarning? = nil

    private let overspendThreshold: Double = 95.0   // 95% of the allocated budget for needs/want
    
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
    
    private func willBreakGoal() -> Bool {
        if selectedType == "Savings" {
            return false
        }
        
        let goal = sessionManager.goal
        guard goal > 0 else { return false }
        
        // dont warn if we've saved enough
        let totalSavings = sessionManager.monthlySavingsList.reduce(0) { $0 + $1.cost }
        if totalSavings >= goal {
            return false
        }
        
        let totalBefore =
            sessionManager.monthlyNeedsList.reduce(0) { $0 + $1.cost } +
            sessionManager.monthlyWantsList.reduce(0) { $0 + $1.cost } +
            sessionManager.monthlySavingsList.reduce(0) { $0 + $1.cost }
        
        let leftoverBefore = sessionManager.budgeted - totalBefore
        let leftoverAfter  = leftoverBefore - amount
        
        // with this purchase -> below the goal
        return leftoverBefore >= goal && leftoverAfter < goal
    }

    

    private func projectedCategoryUsage() -> Double? {
        guard let selectedType = selectedType else { return nil }
        
        let percentBudgeted: Double
        let currentSpent: Double
        
        switch selectedType {
        case "Needs":
            percentBudgeted = sessionManager.needs
            currentSpent = sessionManager.monthlyNeedsList.reduce(0) { $0 + $1.cost }
        case "Wants":
            percentBudgeted = sessionManager.wants
            currentSpent = sessionManager.monthlyWantsList.reduce(0) { $0 + $1.cost }
        case "Savings":
            return nil
        default:
            return nil
        }
        
        let income = sessionManager.budgeted
        let categoryBudget = income * percentBudgeted / 100.0
        
        guard categoryBudget > 0 else { return nil }
        
        let totalAfter = currentSpent + amount
        return (totalAfter / categoryBudget) * 100.0
    }
    
    private func performSubmission() async {
        isLoading = true
        defer { isLoading = false }
        
        if await addExpenditure() {
            await sessionManager.fetchAllExpenditures()
            navigateToMain = true
        }
    }
    

    var body: some View {
        NavigationStack {
            ZStack {
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
                                guard selectedType != nil else {
                                    errorMessage = "Select an expenditure type!"
                                    return
                                }
                                
                                guard !title.isEmpty else {
                                    errorMessage = "Input an expenditure title!"
                                    return
                                }
                                
                                guard amount > 0 else {
                                    errorMessage = "Enter a valid amount!"
                                    return
                                }
                                
                                if willBreakGoal() {
                                    activeWarning = .goal
                                    return
                                }
                                
                                // overspending warning
                                if let usage = projectedCategoryUsage(),
                                   usage >= overspendThreshold {
                                    activeWarning = .overspend
                                    return
                                }
                                
                                // submit
                                await performSubmission()
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
                }
                
                if isLoading {
                    LoadingOverlay(message: "Updating your budget...")
                }
            }
            .navigationDestination(isPresented: $navigateToMain) {
                MainView()
            }
            .alert(item: $activeWarning) { warning in
                switch warning {
                case .overspend:
                    let typeLabel: String
                    switch selectedType {
                    case "Needs":   typeLabel = "needs"
                    case "Wants":   typeLabel = "wants"
                    case "Savings": typeLabel = "savings"
                    default:        typeLabel = "this category"
                    }
                    
                    return Alert(
                        title: Text("You are really close or exceeding the budget for \(typeLabel)!"),
                        message: Text("Are you sure you want to make this purchase?"),
                        primaryButton: .default(Text("Yes")) {
                            Task { await performSubmission() }
                        },
                        secondaryButton: .cancel(Text("Cancel Purchase!"))
                    )
                    
                case .goal:
                    return Alert(
                        title: Text("You will fail to save your goal amount this month!"),
                        message: Text("Are you sure you want to make this purchase?"),
                        primaryButton: .default(Text("Yes")) {
                            Task { await performSubmission() }
                        },
                        secondaryButton: .cancel(Text("Cancel Purchase!"))
                    )
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

