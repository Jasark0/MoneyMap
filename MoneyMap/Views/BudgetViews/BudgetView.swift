//
//  BudgetView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI

struct BudgetView: View {
    //temp variables - replace with user data soon
    private let categories: [BudgetCategory] = [
        .init(kind: .needs,   percentBudgeted: 0.50, used: 0.20),
        .init(kind: .wants,   percentBudgeted: 0.30, used: 0.30),
        .init(kind: .savings, percentBudgeted: 0.20, used: 0.90)
    ]
    
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

                    Text("\(Int(category.percentBudgeted * 100))% budgeted")
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
    let progress: Double   // 0...1
    let tint: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(Color.gray.opacity(0.22))
                Capsule()
                    .fill(tint)
                    .frame(width: max(8, CGFloat(progress) * geo.size.width))
            }
        }
        .frame(height: 14)
    }
}

struct UsedPill: View {
    let usedPercent: Double // 0...1

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(usedPercent < 0.5 ? Color.green : (usedPercent < 0.8 ? Color.yellow : Color.red))
                .frame(width: 8, height: 8)
            Text("Used: \(Int(usedPercent * 100))%")
                .font(.footnote)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule().fill(Color.black.opacity(0.85))
        )
        .foregroundStyle(.white)
    }
}


#Preview {
    NavigationStack {
        BudgetView()
    }
}
