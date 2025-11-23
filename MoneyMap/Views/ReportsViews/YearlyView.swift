import SwiftUI
import Charts

struct YearlyView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @Environment(\.dismiss) private var goback
    
    private let savedThisYear: Double = 7_560
 
    private let H1_wants:   [Double] = [70, 65, 90, 80, 66, 15]
    private let H1_needs:   [Double] = [115, 100, 140, 170, 135, 100]
    private let H1_savings: [Double] = [130, 120, 190, 200, 225, 190]


    private let H2_wants:   [Double] = [5, 25, 12, 18, 22, 28]
    private let H2_needs:   [Double] = [95, 100, 92, 94, 96, 93]
    private let H2_savings: [Double] = [165, 180, 150, 158, 185, 190]

    private let bannerHeight: CGFloat = 84

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Color("Independence").ignoresSafeArea(edges: .top)

                HStack(spacing: 12) {
                    Button {
                        goback() // goes back to reports
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.18))
                            .clipShape(Circle())
                    }
                    Text("Yearly Reports")
                        .font(.system(.title2, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .padding(.top, 8)
            }
            .frame(height: bannerHeight)
            .navigationBarBackButtonHidden(true)


            ScrollView {
                VStack(spacing: 16) {

                    YearHeaderCard(amount: savedThisYear)

                    // Jan–Jun
                    HalfYearChartCard(
                        title: "Jan - Jun",
                        months: ["Jan","Feb","Mar","Apr","May","Jun"],
                        wants: H1_wants,
                        needs: H1_needs,
                        savings: H1_savings
                    )

                    // July–Dec
                    HalfYearChartCard(
                        title: "July - Dec",
                        months: ["Jul","Aug","Sep","Oct","Nov","Dec"],
                        wants: H2_wants, needs: H2_needs, savings: H2_savings
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 88)
            }
        }
    }
}

private struct YearHeaderCard: View {
    let amount: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(amount.formattedCurrencyNoCents())
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(.primary)

            Text("Saved this year!")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.black.opacity(0.12), lineWidth: 1)
                )
        )
    }
}


private struct HalfYearChartCard: View {
    let title: String
    let months: [String]
    let wants: [Double]
    let needs: [Double]
    let savings: [Double]

    struct Row: Identifiable {
        let id = UUID()
        let month: String
        let cat: String   // "Wants" | "Needs" | "Savings"
        let val: Double
    }

    private var rows: [Row] {
        var r: [Row] = []
        for i in months.indices {
            r.append(.init(month: months[i], cat: "Wants",   val: wants[safe: i] ?? 0))
            r.append(.init(month: months[i], cat: "Needs",   val: needs[safe: i] ?? 0))
            r.append(.init(month: months[i], cat: "Savings", val: savings[safe: i] ?? 0))
        }
        return r
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            Chart(rows) { r in
                AreaMark(
                    x: .value("Month", r.month),
                    y: .value("Value", r.val),
                    stacking: .unstacked
                )
                .foregroundStyle(by: .value("Category", r.cat))
                .opacity(0.22)
                .interpolationMethod(.monotone)

                // line directly over its own area
                LineMark(
                    x: .value("Month", r.month),
                    y: .value("Value", r.val)
                )
                .foregroundStyle(by: .value("Category", r.cat))
                .lineStyle(StrokeStyle(lineWidth: 2))
                .interpolationMethod(.monotone)

                // points on the line
                PointMark(
                    x: .value("Month", r.month),
                    y: .value("Value", r.val)
                )
                .symbolSize(26)
                .foregroundStyle(.primary.opacity(0.9))
            }
            .chartLegend(position: .bottom, alignment: .center)
            .chartXAxis {
                AxisMarks(values: months) { _ in
                    AxisGridLine().foregroundStyle(.gray.opacity(0.16))
                    AxisValueLabel().font(.caption)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { _ in
                    AxisGridLine().foregroundStyle(.gray.opacity(0.16))
                    AxisValueLabel().font(.caption2)
                }
            }
            // FIX THESE COLORS
            .chartForegroundStyleScale([
                "Wants":   LinearGradient(
                    colors: [Color(red: 0.53, green: 0.36, blue: 1.00).opacity(0.55),
                             Color(red: 0.53, green: 0.36, blue: 1.00).opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom),

                "Needs":   LinearGradient(
                    colors: [Color(red: 1.00, green: 0.45, blue: 0.45).opacity(0.55),
                             Color(red: 1.00, green: 0.45, blue: 0.45).opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom),

                "Savings": LinearGradient(
                    colors: [Color(red: 0.00, green: 0.78, blue: 0.65).opacity(0.55),
                             Color(red: 0.00, green: 0.78, blue: 0.65).opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom)


            ])
            .frame(height: 240)
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.black.opacity(0.12), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
                )
        )
    }
}

// Safe subscript helper
private extension Array {
    subscript(safe index: Index) -> Element? { indices.contains(index) ? self[index] : nil }
}


// rounding
private extension Double {
    func formattedCurrencyNoCents(locale: Locale = .current) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = locale
        nf.maximumFractionDigits = 0
        nf.minimumFractionDigits = 0
        return nf.string(from: NSNumber(value: self)) ?? "$\(Int(self))"
    }
}



#Preview {
    YearlyView()
}
