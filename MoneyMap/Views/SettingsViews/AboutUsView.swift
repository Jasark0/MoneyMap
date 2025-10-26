import SwiftUI

struct AboutUsView: View {
    private let bannerHeight: CGFloat = 84

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Banner
                ZStack(alignment: .leading) {
                    Color("Independence").ignoresSafeArea(edges: .top)
                    Text("About Us")
                        .font(.system(.title2, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                        .padding(.top, 8)
                }
                .frame(height: bannerHeight)

                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Welcome to MoneyMap!")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Royal Blue"))

                        Text("""
MoneyMap is your personal finance companion, built to help you take control of your budget and spending habits. 

With easy-to-understand charts, clear budgeting categories, and simple navigation, you can track your income, expenses, and savings in one place.

Our goal is to make budgeting stress-free — helping you visualize where your money goes each month, stay on top of your goals, and make smarter financial decisions.

Thank you for using MoneyMap and taking a step toward better financial awareness!
""")
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 4)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
            }
        }
    }
}

#Preview {
    AboutUsView()
}

