import SwiftUI

struct ReportView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    func formatCurrency(_ amount: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 0  
        return f.string(from: NSNumber(value: amount)) ?? "$0"
    }
    var totalMonthlyExpenditure: Double {
        sessionManager.monthlyNeedsList.reduce(0) { $0 + $1.cost } +
        sessionManager.monthlyWantsList.reduce(0) { $0 + $1.cost } +
        sessionManager.monthlySavingsList.reduce(0) { $0 + $1.cost }
    }
    
    var totalYearlyExpenditure :Double {
        sessionManager.yearlyNeedsList.reduce(0) { $0 + $1.cost } +
        sessionManager.yearlyWantsList.reduce(0) { $0 + $1.cost } +
        sessionManager.yearlySavingsList.reduce(0) { $0 + $1.cost }
    }
    
    var budgeted: Double {
        sessionManager.budgeted
    }
    
    var goal: Double {
        sessionManager.goal
    }
    
    var monthlyPercentage: Double {
        totalMonthlyExpenditure / budgeted * 100
    }
    
    var yearlyPercentage: Double {
        totalYearlyExpenditure / (budgeted * 12) * 100
    }
    
    var goalPercentage: Double {
        let raw = (budgeted - totalMonthlyExpenditure) / goal * 100
        return min(max(raw, 0), 100)
    }
    
    var saved: Double {
        let raw = budgeted - totalMonthlyExpenditure
        return max(raw, 0)
    }
    
    private var cards: [ReportsCardModel] {
        [
            .init(kind: .monthly,
                  progress: monthlyPercentage,
                  subtitle: "Used: \(Int(monthlyPercentage))%"),
            
            .init(kind: .yearly,
                  progress: yearlyPercentage,
                  subtitle: "Used: \(Int(yearlyPercentage))%"),
            
            .init(kind: .goal,
                  progress: goalPercentage,
                  subtitle: "Met \(Int(goalPercentage))%, Saved \(formatCurrency(saved)) this month!")
        ]
    }


    private let bannerHeight: CGFloat = 84

    var body: some View {
        VStack {

            ZStack(alignment: .leading) {
                Color("Independence").ignoresSafeArea(edges: .top)
                Text("Reports")
                    .font(.system(.title2, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .padding(.top, 8)
            }
            .frame(height: bannerHeight)

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(cards) { card in
                        if card.kind == .goal {
                            ReportCard(card: card, showChevron: false)
                        } else {
                            NavigationLink {
                                switch card.kind {
                                case .monthly: MonthlyView()
                                case .yearly: YearlyView()
                                case .goal: EmptyView() // not used
                                }
                            } label: {
                                ReportCard(card: card, showChevron: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}


private struct ReportCard: View {
    let card: ReportsCardModel
    var showChevron: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 70)

                VStack(alignment: .leading, spacing: 6) {
                    Text(card.kind.title)
                        .font(.system(.title3, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(card.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if showChevron {
                    HStack(spacing: 6) {
                        Text("View All")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            HStack(spacing: 12) {
                UsedPill(usedPercent: card.progress, kind: card.kind)
                ProgressBar(progress: card.progress, tint: card.kind.accent)
            }
        }
        .padding(16)
        .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        // gold  glow when goal is met
                        .shadow(color: card.kind == .goal && card.progress >= 1.0
                                    ? Color.yellow.opacity(0.6)
                                    : .black.opacity(0.06),
                                radius: card.kind == .goal && card.progress >= 1.0 ? 12 : 8,
                                y: card.kind == .goal && card.progress >= 1.0 ? 4 : 2)
                )
        .accessibilityAddTraits(showChevron ? .isButton : [])
    }
}

#Preview { ReportView() }
