import SwiftUI

struct ReportView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    private let cards: [ReportsCardModel] = [
        .init(kind: .monthly, progress: 0.75, subtitle: "Used: 75%"),
        .init(kind: .yearly,  progress: 0.10, subtitle: "Used: 10%"),
        .init(kind: .goal,    progress: 1.00, subtitle: "Met 100%")
    ]

    private let bannerHeight: CGFloat = 84

    var body: some View {
        VStack(spacing: 0) {

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
