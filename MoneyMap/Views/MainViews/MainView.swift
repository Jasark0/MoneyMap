import SwiftUI
import Charts

struct MainView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    let budgeted: Double = 5000
    let left: Double = 1000
    let monthlyGoal: Double = 500
    
    let baseColors: [Color] = [
        Color("Royal Blue"),
        Color("Wild Blue Yonder"),
        Color("Independence")
    ]
    
    let pieData: [(category: String, percent: Double)] = [
        ("Needs", 50),
        ("Wants", 30),
        ("Savings", 20)
    ]
    
    let usageMultipliers: [Double] = [0.9, 0.1, 0.6]
    
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
                        Text("$\(Int(budgeted)) budgeted this month")
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
                        Text("$\(Int(monthlyGoal)) monthly goal")
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
