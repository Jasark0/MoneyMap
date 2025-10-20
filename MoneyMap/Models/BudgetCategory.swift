//
//  BudgetCategory.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 10/19/25.
//

import Foundation
import SwiftUI
import Supabase
import Combine

struct BudgetCategory: Identifiable, Hashable {
    let id = UUID()
    let kind: BudgetKind
    let percentBudgeted: Double  // e.g., 0.50
    let used: Double             // e.g., 0.20
}


enum BudgetKind: Hashable {
    case needs, wants, savings
    var title: String {
        switch self {
        case .needs: return "Needs"
        case .wants: return "Wants"
        case .savings: return "Savings"
        }
    }
    var accent: Color { Color("Oxford Blue") }
}
