import SwiftUI
import SwiftData

struct ContentView: View {
    @EnvironmentObject var sessionManager: SessionManager

    var body: some View {
        Group {
            if sessionManager.isLoggedIn {
                MainShellView()
            } else {
                //GetStartedView()
                SplashView()
            }
        }
        .onAppear {
            sessionManager.restoreSession()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionManager.preview)
}



