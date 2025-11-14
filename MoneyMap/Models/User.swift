import Foundation
import Supabase
import SwiftUI
import Combine

struct UserEmail: Codable {
    let email: String?
}

struct UserProfile: Codable {
    let id: UUID?
    let username: String?
    let first_name: String?
    let last_name: String?
}

struct IncomeRecord: Codable {
    let income: Double
    let goal: Double
    let needs: Double
    let wants: Double
    let savings: Double
}

@MainActor
class SessionManager: ObservableObject {
    @Published var userId: UUID? = nil
    
    @Published var userEmail: String? = nil
    @Published var username: String? = nil
    @Published var firstName: String? = nil
    @Published var lastName: String? = nil
    @Published var isLoggedIn: Bool = false
    
    @Published var budgeted: Double = 0
    @Published var goal: Double = 0
    @Published var needs: Double = 0
    @Published var wants: Double = 0
    @Published var savings: Double = 0
    
    func signIn(id: UUID) {
        self.userId = id
        self.isLoggedIn = true
        UserDefaults.standard.set(id.uuidString, forKey: "userId")
        Task {
            await fetchEmail()
            await fetchProfile()
            await fetchIncome()
        }
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
            Task {
                await fetchEmail()
                await fetchProfile()
                await fetchIncome()
            }
        }
    }
    
    func fetchEmail() async {
        guard let userId = userId else {
            print("No userId found")
            return
        }
        
        do {
            let userEmails: [UserEmail] = try await supabase
                .from("profile_emails")
                .select("email")
                .eq("id", value: userId)
                .execute()
                .value
            
            if let email = userEmails.first {
                self.userEmail = email.email
            } else {
                print("No email found for this user ID")
            }
        } catch {
            print("Error fetching email:", error)
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
                .select("*")
                .eq("id", value: userId)
                .execute()
                .value
            
            if let profile = profiles.first {
                self.username = profile.username
                self.firstName = profile.first_name
                self.lastName = profile.last_name
            } else {
                print("No profile found for this user ID")
            }
        } catch {
            print("Error fetching profile:", error)
        }
    }
    
    func fetchIncome() async {
        guard let userId = userId else {
            print("No userId found")
            return
        }
        
        do {
            let incomes: [IncomeRecord] = try await supabase
                .from("income")
                .select("*")
                .eq("id", value: userId)
                .execute()
                .value
            
            if let income = incomes.first {
                self.budgeted = income.income
                self.goal = income.goal
                self.needs = income.needs
                self.wants = income.wants
                self.savings = income.savings
            } else {
                print("No income record found for this user")
                self.budgeted = 0
                self.goal = 0
            }
        } catch {
            print("Error fetching budgeted amount:", error)
            self.budgeted = 0
            self.goal = 0
        }
    }
    
    static var preview: SessionManager {
        let manager = SessionManager()
        manager.firstName = "PreviewUser"
        return manager
    }
}
