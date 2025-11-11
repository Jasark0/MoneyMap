import SwiftUI
import Supabase

struct SetupView: View {
    let userId: UUID
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var income: Double = 500
    @State private var goal: Double = 0
    @State private var needs: Double = 50
    @State private var wants: Double = 30
    @State private var savings: Double = 20
    
    @State private var showPercentageWarning = false
    @State private var errorMessage: String? = nil
    @State private var navigateToMain = false
    
    struct Profile: Encodable{
        let id: String
        let income: Double
        let goal: Double
        let needs: Double
        let wants: Double
        let savings: Double
    }
    
    func setUp() async {
        do {
            errorMessage = nil
            
            let total = needs + wants + savings
            
            guard total == 100 else{
                errorMessage = "Your percentages must add up to 100%!"
                return
            }
            
            let profile = Profile(
                id: userId.uuidString,
                income: income,
                goal: goal,
                needs: needs,
                wants: wants,
                savings: savings,
            )
            
            try await supabase
                .from("income")
                .insert(profile)
                .execute()
            
            sessionManager.signIn(id: userId)
            
            navigateToMain = true
        }
        catch{
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Welcome to MoneyMap!")
                        .font(.system(size: 28))
                        .padding(.top, 15)
                        .padding(.bottom, 5)
                        
                    Text("Tell us about yourself")
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 25){
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
                            await setUp()
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
                    MainShellView()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        SetupView(userId: UUID())
            .environmentObject(SessionManager.preview)
    }
}

