//
//  MainView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI
import Charts

struct MainView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    let budgeted: Double = 5000
    let left: Double = 1000
    let monthlyGoal: Double = 500
    
    // Base color set
    let baseColors: [Color] = [
        Color("Royal Blue"),
        Color("Wild Blue Yonder"),
        Color("Independence")
    ]
    
    // Budgeted data
    let pieData: [(category: String, percent: Double)] = [
        ("Needs", 50),
        ("Wants", 30),
        ("Savings", 20)
    ]
    
    // Actual usage multipliers (e.g. 90% of Needs)
    let usageMultipliers: [Double] = [0.9, 0.1, 0.6]
    
    // Derived actual usage data
    var actualUsageData: [(category: String, percent: Double, color: Color)] {
        zip(pieData, baseColors).enumerated().map { (index, pair) in
            let (data, color) = pair
            let actual = data.percent * usageMultipliers[index]
            return (data.category, actual, color)
        }
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
                        } else {
                            ProgressView()
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
                        
                        PieChartView(
                            pieData: pieData.map { CategoryData(category: $0.category, percent: $0.percent) },
                            baseColors: baseColors
                        )
                        .frame(width: 220, height: 220)

                        Spacer()
                        
                        // Legend – horizontal style with capsules
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
                    
                    // Monthly goal
                    VStack(alignment: .leading, spacing: 5) {
                        Text("$\(Int(monthlyGoal)) monthly goal")
                            .font(.headline)
                        Text("On track to reach the goal this month")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // Button
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
