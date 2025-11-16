import SwiftUI
import Charts

struct MainView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    var totalNeeds: Double {
        sessionManager.needsList.reduce(0) { $0 + $1.cost }
    }

    var totalWants: Double {
        sessionManager.wantsList.reduce(0) { $0 + $1.cost }
    }

    var totalSavings: Double {
        sessionManager.savingsList.reduce(0) { $0 + $1.cost }
    }
    var left: Double {
        totalNeeds + totalWants + totalSavings
    }
    var budgeted: Double {
        sessionManager.budgeted
    }
    var needs: Double {
        sessionManager.needs
    }
    var wants: Double {
        sessionManager.wants
    }
    var savings: Double {
        sessionManager.savings
    }
    var goal: Double {
        sessionManager.goal
    }
    
    let baseColors: [Color] = [
        Color("Royal Blue"),
        Color("Wild Blue Yonder"),
        Color("Independence")
    ]
    
    var pieData: [(category: String, percent: Double)] {
        [
            ("Needs", needs),
            ("Wants", wants),
            ("Savings", savings)
        ]
    }
    
    var needsPercent: Double {
        guard budgeted * needs / 100 != 0 else { return 0 }
        return totalNeeds / (budgeted * needs / 100)
    }
    var wantsPercent: Double {
        guard budgeted * wants / 100 != 0 else { return 0 }
        return totalWants / (budgeted * wants / 100)
    }
    var savingsPercent: Double {
        guard budgeted * savings / 100 != 0 else { return 0 }
        return totalSavings / (budgeted * savings / 100)
    }
    var usageMultipliers: [Double] {
        [needsPercent, wantsPercent, savingsPercent]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 8) {
                        if let name = sessionManager.firstName {
                            Text("Welcome back,")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text(name + "!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        else {
                            Text("Loading profile...")
                                .foregroundColor(.gray)
                        }
                        
                        Text("$\(Int(left)) left")
                            .font(.title2)
                            .foregroundColor(Color("Royal Blue"))
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                    VStack(spacing: 5) {
                        Text("$\(Int(budgeted)) budgeted this month" )
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        Spacer()
                        
                        NavigationLink(destination: BudgetView()){
                            PieChartView(
                                pieData: pieData.map { CategoryData(category: $0.category, percent: $0.percent) },
                                baseColors: baseColors
                            )
                            .frame(width: 220, height: 220)
                        }
                        
                        Spacer()
                        
                        Text("Budgets used")
                            .font(.caption)
                            .padding(.horizontal)

                            HStack(spacing: 8) {
                                ForEach(Array(zip(pieData.indices, pieData)), id: \.0) { index, item in
                                    HStack(spacing: 4) {
                                        Circle()
                                            .fill(baseColors[index])
                                            .frame(width: 12, height: 12)
                                        Text("\(item.category): \(Int(usageMultipliers[index] * 100))%")
                                            .font(.caption2)
                                            .foregroundColor(.white)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(baseColors[index].opacity(0.8))
                                    .clipShape(Capsule())
                                }
                            }
                            .padding(.vertical, 4)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("$\(Int(goal)) monthly goal")
                            .font(.headline)
                        Text("On track to reach the goal this month")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    NavigationLink(destination: ExpenditureView()) {
                        Text("Add Expenditure")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("Oxford Blue"))
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(SessionManager.preview)
}
