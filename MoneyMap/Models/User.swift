import Foundation
import Supabase
import SwiftUI
import Combine

struct UserProfile: Codable {
    let id: UUID?
    let first_name: String?
}

@MainActor
class SessionManager: ObservableObject {
    @Published var userId: UUID? = nil
    @Published var firstName: String? = nil
    @Published var isLoggedIn: Bool = false
    
    func signIn(id: UUID) {
        self.userId = id
        self.isLoggedIn = true
        UserDefaults.standard.set(id.uuidString, forKey: "userId")
        Task { await fetchProfile() }
    }
    
    func signOut() {
        self.userId = nil
        self.isLoggedIn = false
        self.firstName = nil
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    func restoreSession() {
        if let idString = UserDefaults.standard.string(forKey: "userId"),
           let uuid = UUID(uuidString: idString) {
            self.userId = uuid
            self.isLoggedIn = true
            Task { await fetchProfile() }
        }
    }
    
    func fetchProfile() async {
        guard let userId = userId else {
            print("No userId found")
            return
        }

        do {
            let profiles: [UserProfile] = try await supabase
                .from("profiles")
                .select("id, first_name")
                .eq("id", value: userId)
                .execute()
                .value
            
            if let profile = profiles.first {
                self.firstName = profile.first_name
            } else {
                print("No profile found for this user ID")
            }
        } catch {
            print("Error fetching profile:", error)
        }
    }

    static var preview: SessionManager {
        let manager = SessionManager()
        manager.firstName = "PreviewUser"
        return manager
    }
}
