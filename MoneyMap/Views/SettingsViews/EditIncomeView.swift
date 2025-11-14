import SwiftUI
import Supabase

struct EditIncomeView: View {
    @EnvironmentObject var sessionManager: SessionManager

    @State private var income: Double = 0
    @State private var goal: Double = 0
    @State private var needs: Double = 50
    @State private var wants: Double = 30
    @State private var savings: Double = 20

    @State private var navigateToSettings = false
    @State private var showSavedMessage = false
    @State private var errorMessage: String? = nil

    private func updateIncome() async -> Bool {
        guard let userId = sessionManager.userId else {
            print("No userId found")
            return false
        }

        let total = needs + wants + savings
        guard total == 100 else {
            errorMessage = "Your percentages must add up to 100%!"
            return false
        }

        do {
            let updates = [
                "income": income,
                "goal": goal,
                "needs": needs,
                "wants": wants,
                "savings": savings
            ]
            
            try await supabase
                .from("income")
                .update(updates)
                .eq("id", value: userId)
                .execute()
            
            errorMessage = nil
            
            sessionManager.budgeted = income
            sessionManager.goal = goal
            sessionManager.needs = needs
            sessionManager.wants = wants
            sessionManager.savings = savings
            return true
            
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
            return false
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Edit Income")
                        .font(.system(size: 28))
                        .fontWeight(.bold)

                    VStack(spacing: 25) {
                        SetupInputView(title: "Monthly Income", placeHolder: "$", number: $income)
                        SetupInputView(title: "Goal", placeHolder: "$", number: $goal)
                        SetupInputView(title: "Needs %", placeHolder: "%", number: $needs)
                        SetupInputView(title: "Wants %", placeHolder: "%", number: $wants)
                        SetupInputView(title: "Savings %", placeHolder: "%", number: $savings)
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
                            let success = await updateIncome()
                            if success {
                                withAnimation {
                                    showSavedMessage = true
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showSavedMessage = false
                                        navigateToSettings = true
                                    }
                                }
                            }
                        }
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
                .navigationDestination(isPresented: $navigateToSettings) {
                    SettingsView()
                }
                .onAppear {
                    income = sessionManager.budgeted
                    goal = sessionManager.goal
                    needs = sessionManager.needs
                    wants = sessionManager.wants
                    savings = sessionManager.savings
                }
            }
            .overlay(
                Group {
                    if showSavedMessage {
                        Text("Income saved successfully!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green.opacity(0.9))
                            .cornerRadius(12)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 60)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        EditIncomeView()
            .environmentObject(SessionManager.preview)
    }
}
