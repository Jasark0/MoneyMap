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
    let pieData: [(category: String, percent: Double, color: Color)] = [
        ("Needs", 50, Color.blue),
        ("Wants", 30, Color.orange),
        ("Savings", 20, Color.green)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    
                    // MARK: Welcome & Left Money
                    VStack(alignment: .leading, spacing: 8) {
                        if let name = sessionManager.firstName {
                            Text("Welcome back, \(name)!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        } else {
                            ProgressView()
                            Text("Loading profile...")
                                .foregroundColor(.gray)
                        }
                        
                        Text("$\(Int(left)) left")
                            .font(.title2)
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: Budgeted This Month
                    VStack(spacing: 5) {
                        Text("$\(Int(budgeted)) budgeted this month")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // MARK: Pie Chart
                        Chart {
                            ForEach(pieData, id: \.category) { item in
                                SectorMark(
                                    angle: .value("Percent", item.percent),
                                    innerRadius: .ratio(0.5),
                                    angularInset: 1
                                )
                                .foregroundStyle(item.color)
                            }
                        }
                        .frame(height: 200)
                        .padding(.horizontal)
                        
                        // MARK: Pie chart labels / tabs
                        HStack(spacing: 20) {
                            ForEach(pieData, id: \.category) { item in
                                VStack {
                                    Circle()
                                        .fill(item.color)
                                        .frame(width: 15, height: 15)
                                    Text("\(Int(item.percent))% \(item.category)")
                                        .font(.caption)
                                }
                            }
                        }
                        .padding(.top, 10)
                    }
                    
                    // MARK: Monthly Goal
                    VStack(alignment: .leading, spacing: 5) {
                        Text("$\(Int(monthlyGoal)) monthly goal")
                            .font(.headline)
                        Text("On track to reach the goal this month")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    
                    // MARK: Expenditure Button
                    NavigationLink(destination: ExpenditureView()) {
                        Text("Add Expenditure")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
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
