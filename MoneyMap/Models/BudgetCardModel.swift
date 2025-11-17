import Foundation
import SwiftUI
import Supabase
import Combine

struct BudgetCardModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let amount: Double
    let percentOfBudget: Double   // 0...1
    let description: String
    let created_at: Date
}
