import SwiftUI

struct BudgetView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    func usedPercent(totalSpent: Double, percentBudgeted: Double) -> Double {
        let budget = sessionManager.budgeted * percentBudgeted / 100
        guard budget > 0 else { return 0 }
        
        return (totalSpent / budget) * 100
    }
    
    var totalNeeds: Double {
        sessionManager.monthlyNeedsList.reduce(0) { $0 + $1.cost }
    }

    var totalWants: Double {
        sessionManager.monthlyWantsList.reduce(0) { $0 + $1.cost }
    }

    var totalSavings: Double {
        sessionManager.monthlySavingsList.reduce(0) { $0 + $1.cost }
    }
    
    var categories: [BudgetCategory] {
        [
            .init(kind: .needs,   percentBudgeted: sessionManager.needs,   used: usedPercent(totalSpent: totalNeeds, percentBudgeted: sessionManager.needs)),
            .init(kind: .wants,   percentBudgeted: sessionManager.wants,   used: usedPercent(totalSpent: totalWants, percentBudgeted: sessionManager.wants)),
            .init(kind: .savings, percentBudgeted: sessionManager.savings, used: usedPercent(totalSpent: totalSavings, percentBudgeted: sessionManager.savings))
        ]
    }

    
    private let bannerHeight: CGFloat = 84

    var body: some View {
         VStack(spacing: 0) {

             ZStack(alignment: .leading) {
                 Color("Independence").ignoresSafeArea(edges: .top)
                 Text("Budget Breakdown")
                     .font(.system(.title2, weight: .semibold))
                     .foregroundStyle(.white)
                     .padding(.horizontal, 16)
                     .padding(.bottom, 12)
                     .padding(.top, 8)
             }
             .frame(height: bannerHeight)

             ScrollView {
                 VStack(spacing: 16) {
                     ForEach(categories) { cat in
                         NavigationLink {
                             // route based on the enum
                             switch cat.kind {
                             case .needs:   NeedsView()
                             case .wants:   WantsView()
                             case .savings: SavingsView()
                             }
                         } label: {
                             BudgetCard(category: cat)
                         }
                         .buttonStyle(.plain)
                     }

                 }
                 .padding(.horizontal, 16)
                 .padding(.top, 12)
                 .padding(.bottom, 24)
             }
         }
         .toolbar(.hidden, for: .navigationBar) // custom banner
     }
 }


struct BudgetCard: View {
    let category: BudgetCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 70)

                VStack(alignment: .leading, spacing: 6) {
                    Text(category.kind.title)
                        .font(.system(.title3, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text("\(Int(category.percentBudgeted))% budgeted")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                HStack(spacing: 6) {
                    Text("View All")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }

            // pill + progress
            HStack(spacing: 12) {
                UsedPill(usedPercent: category.used)

                let clamped = min(max(category.used, 0), 100)
                ProgressBar(progress: category.used, tint: category.kind.accent)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
        )
        .contentShape(Rectangle())
    }
}


struct ProgressBar: View {
    let progress: Double   // expected 0...100
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            let clamped = min(max(progress, 0), 100.0)
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.22))
                Capsule()
                    .fill(tint)
                    .frame(
                        width: max(8, CGFloat(clamped / 100) * geo.size.width)
                    )
            }
        }
        .frame(height: 14)
    }
}

struct UsedPill: View {
    let usedPercent: Double      // 0...100+ (may be >100 for displayed text)
    let reportKind: ReportsKind? // ReportsView only

    init(usedPercent: Double, kind: ReportsKind? = nil) {
        self.usedPercent = usedPercent
        self.reportKind = kind
    }

    var body: some View {
        let isGoal = (reportKind == .goal)
        let textLabel = isGoal ? "Goal" : "Used"
        let clamped = min(max(usedPercent, 0), 100)

        let color: Color = {
            if isGoal {
                if clamped < 20 {
                    return .red
                } else if clamped < 100 {
                    return .yellow
                } else {
                    return .green
                }
            } else {
                if clamped < 50 {
                    return .green
                } else if clamped < 80 {
                    return .yellow
                } else {
                    return .red
                }
            }
        }()

        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text("\(textLabel): \(Int(usedPercent))%")
                .font(.footnote)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Capsule().fill(Color.black.opacity(0.85)))
        .foregroundStyle(.white)
    }
}

#Preview {
    NavigationStack {
        BudgetView()
    }
}
