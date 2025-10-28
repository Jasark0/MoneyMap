import SwiftUI

struct SavingsView: View {
    // dummy data
    private let items: [BudgetCardModel] = [
        .init(title: "Emergency Fund", amount: 300.00, percentOfBudget: 0.50, description: "in case i don't live tomorrow")
    ]

    private let bannerHeight: CGFloat = 84

    var body: some View {
        VStack(spacing: 0) {
            DetailBanner(title: "Savings", height: bannerHeight)
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(items) { item in
                        LineItemCard(item: item)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .background(Color(.systemBackground))
    }
}

//banner + title
private struct DetailBanner: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    var height: CGFloat = 84

    var body: some View {
        ZStack {
            Color("Independence").ignoresSafeArea(edges: .top)

            HStack(spacing: 12) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.white.opacity(0.08))
                        .clipShape(Circle())
                }
                Text(title)
                    .font(.system(.title3, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .frame(height: height)
    }
}

//card
private struct LineItemCard: View {
    let item: BudgetCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(item.title) – \(currency(item.amount)) (\(percent(item.percentOfBudget)))")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.primary)

            Divider()
                .frame(height: 1)
                .overlay(Color.black.opacity(0.08))

            Text("Desc: \(item.description)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }

    private func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func percent(_ value: Double) -> String {
        // convert to precent
        let p = Int(round(value * 100))
        return "\(p)%"
    }
}

#Preview {
    SavingsView()
}
