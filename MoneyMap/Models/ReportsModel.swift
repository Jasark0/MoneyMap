//
//  ReportsModel.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 10/26/25.
//

import Foundation
import SwiftUI
import Supabase
import Combine

enum ReportsKind: Hashable {
    case monthly, yearly, goal
    var title: String{
        switch self{
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .goal: return "Goal"
        }
    }
    var accent: Color { Color("Oxford Blue") }
}

struct ReportLineItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let amount: Double
    let percentage: Double
    let kind: BudgetKind        // needs-wants-savings
    let description: String?
    let date : Date
}

struct YearlySummary: Identifiable, Hashable {
    let id = UUID()
    let year: Int
    let savedAmount : Double
    let firstHalf : [Double] // jan to jun
    let secondHalf : [Double] // july to dec
}
