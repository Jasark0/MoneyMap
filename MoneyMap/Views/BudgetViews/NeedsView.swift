import SwiftUI
import Supabase

struct NeedsView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    private var items: [ExpenditureItemWrapper] {
        let income = sessionManager.budgeted
        let needsPercent = sessionManager.needs / 100
        let needsBudget = income * needsPercent
        
        return sessionManager.monthlyNeedsList.map { item in
            let percentOfBudget = item.cost / needsBudget
            return ExpenditureItemWrapper(item: item, percentOfBudget: percentOfBudget)
        }
    }

    private let bannerHeight: CGFloat = 84

    var body: some View {
        VStack(spacing: 0) {
            DetailBanner(title: "Needs", height: bannerHeight)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(items) { wrapper in
                        LineItemCard(item: wrapper.item, percentOfBudget: wrapper.percentOfBudget) { id in
                            deleteNeed(id: id)
                        }
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

    func deleteNeed(id: UUID) {
        Task {
            do {
                try await supabase
                    .from("monthly_needs")
                    .delete()
                    .eq("expenditure_id", value: id)
                    .execute()
                
                // Refresh session manager data
                await sessionManager.fetchAllExpenditures()
            } catch {
                print("Error deleting expense:", error)
            }
        }
    }
}

private struct DetailBanner: View {
    @Environment(\.dismiss) private var goback
    let title: String
    var height: CGFloat = 84

    var body: some View {
        ZStack {
            Color("Independence").ignoresSafeArea(edges: .top)
            
            HStack(spacing: 12) {
                Button {
                    goback()
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

private struct LineItemCard: View {
    let item: ExpenditureItem
    let percentOfBudget: Double
    let onDelete: (UUID) -> Void
    
    @State private var showDeleteConfirmation = false
    
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MMMM d, yyyy"
        return df
    }()
    
    private var formattedDate: String? {
        guard let createdAtStr = item.created_at else { return nil }
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = isoFormatter.date(from: createdAtStr) {
            return dateFormatter.string(from: date)
        }
        return nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("\(item.title) – \(currency(item.cost)) (\(percent(percentOfBudget)))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            Divider()
                .overlay(Color.black.opacity(0.08))
            
            HStack {
                if let desc = item.description, !desc.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text("Desc: \(desc)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let dateText = formattedDate {
                    Text(dateText)
                        .font(.subheadline)
                }
            }
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
        .confirmationDialog(
            "Delete this item?",
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                onDelete(item.expenditure_id)
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func currency(_ value: Double) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.maximumFractionDigits = 2
        return f.string(from: NSNumber(value: value)) ?? "$0.00"
    }

    private func percent(_ value: Double) -> String {
        "\(Int(round(value * 100)))%"
    }
}

#Preview {
    NeedsView()
        .environmentObject(SessionManager.preview)
}
