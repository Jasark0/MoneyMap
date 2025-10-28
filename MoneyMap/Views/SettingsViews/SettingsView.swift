import SwiftUI
import Supabase

struct SettingsView: View {
    private let bannerHeight: CGFloat = 84
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var sessionManager: SessionManager
    
    struct SettingsCard: View {
        let title: String

        var body: some View {
            HStack {
                Text(title)
                    .font(.title3)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.white)
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("Royal Blue"))
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 2)
            )
            .contentShape(Rectangle())
        }
    }

    var body: some View {
        VStack(spacing: 32) {
            ZStack(alignment: .leading) {
                Color("Independence").ignoresSafeArea(edges: .top)
                HStack {
                    Text("Settings")
                        .font(.system(.title2, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.leading, 8)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 12)
                .padding(.top, 8)
            }
            .frame(height: bannerHeight)
            
            ScrollView {
                VStack(spacing: 40) {
                    NavigationLink(destination: ProfileView()) {
                        SettingsCard(title: "Profile")
                    }
                    NavigationLink(destination: EditIncomeView()) {
                        SettingsCard(title: "Update Income")
                    }
                    NavigationLink(destination: AboutUsView()) {
                        SettingsCard(title: "About Us")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            
            Button(action: {
                sessionManager.signOut() 
            }) {
                Text("Log Out")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(15)
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 70)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SessionManager.preview)
    }
}
