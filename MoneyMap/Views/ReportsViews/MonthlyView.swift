//
//  MonthlyView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI

struct MonthlyView: View {
    @Environment(\.dismiss) private var goback
    
    // dummy data for now - set for october except emergency funds set to sept
    @State private var monthAnchor: Date = fixedDate(month: 10, day: 1, year: 2025)
    private var month: Int { Calendar.current.component(.month, from: monthAnchor) }
    private var year:  Int { Calendar.current.component(.year,  from: monthAnchor) }

    @State private var allItems: [ReportLineItem] = [
        .init(title: "Car Insurance", amount: 45.99, percentage: 0.04, kind: .needs,
              description: "I paid this", date: fixedDate(month: 10, day: 26, year: 2025)),
        .init(title: "Rent", amount: 900, percentage: 0.7828, kind: .needs,
              description: "I paid this", date: fixedDate(month: 10, day: 28, year: 2025)),
        .init(title: "Labubu", amount: 23.99, percentage: 0.10, kind: .wants,
              description: "Labububububu", date: fixedDate(month: 10, day: 23, year: 2025)),
        .init(title: "Emergency Funds", amount: 50, percentage: 0.30, kind: .savings,
              description: "In case I don't live tomorrow.", date: fixedDate(month: 9, day: 18, year: 2025))
    ]

    // get only the items of that month
    private var itemsForMonth: [ReportLineItem] {
        let cal = Calendar.current
        return allItems
            .filter {
                cal.component(.month, from: $0.date) == month &&
                cal.component(.year,  from: $0.date) == year
            }
            .sorted { $0.date < $1.date } //sort in accending order
    }

    // split into needs, wants, savings
    private var needs:   [ReportLineItem] { itemsForMonth.filter { $0.kind == .needs } }
    private var wants:   [ReportLineItem] { itemsForMonth.filter { $0.kind == .wants } }
    private var savings: [ReportLineItem] { itemsForMonth.filter { $0.kind == .savings } }

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Color("Independence").ignoresSafeArea(edges: .top)
                HStack(spacing: 12) {
                    Button {
                        goback()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Circle())
                    }
                    Text("Monthly Reports")
                        .font(.system(.title2, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .padding(.top, 8)
            }
            .frame(height: 84)

            ScrollView {
                VStack(spacing: 16) {
                    ReportSection(title: "Needs",   items: needs,   viewAll: { NeedsView() })
                    ReportSection(title: "Wants",   items: wants,   viewAll: { WantsView() })
                    ReportSection(title: "Savings", items: savings, viewAll: { SavingsView() })
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

//remove once connected to db
private func fixedDate(month: Int, day: Int, year: Int? = nil) -> Date {
    let cal = Calendar.current
    let y = year ?? cal.component(.year, from: .now)
    return cal.date(from: DateComponents(year: y, month: month, day: day))!
}

private struct ReportSection<Destination: View>: View {
    let title: String
    let items: [ReportLineItem]
    @ViewBuilder var viewAll: () -> Destination   // accepts a destination view

    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                NavigationLink {
                    viewAll()  // goes to the passed-in view -eg needs, savings, wants
                } label: {
                    HStack(spacing: 6) {
                        Text("View All")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
            }

            ForEach(items) { item in
                MonthlyLineItemRow(item: item)
            }
        }
    }
}


private struct MonthlyLineItemRow: View {
    let item: ReportLineItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Title – $Amount Percent%     MM/DD
            HStack(alignment: .firstTextBaseline) {
                Text("\(item.title) – \(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD")) (\(Int(item.percentage * 100))%)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Spacer()

                Text(item.date, formatter: DateFormatter.mmdd)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .monospacedDigit()  //10/29 takes the same space as 10/28
            }

            if let desc = item.description, !desc.isEmpty { //shows the descp
                Text("Desc: \(desc)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
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

private extension DateFormatter {
    static let mmdd: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "MM/dd"
        return df
    }()
}

private extension View {
    func appCardStyle() -> some View {
        self
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
            )
            .contentShape(Rectangle())
    }
}

#Preview {
    MonthlyView()
}

