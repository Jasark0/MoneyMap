import SwiftUI
import Supabase

struct ProfileView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""

    @State private var showSavedMessage = false
    @State private var navigateToForgotPassword = false
    @State private var navigateToSettings = false
    
    @State private var errorMessage: String? = nil
    private let bannerHeight: CGFloat = 84
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func updateProfile(firstName: String, lastName: String, username: String) async -> Bool {
        guard let userId = sessionManager.userId else {
            print("No userId found")
            return false
        }
        
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            return false
        }
        
        guard username.count >= 6 else{
            errorMessage = "Username must be least 6 characters."
            return false
        }
        
        do {
            let updates = [
                "first_name": firstName,
                "last_name": lastName,
                "username": username
            ]
            
            try await supabase
                .from("profiles")
                .update(updates)
                .eq("id", value: userId)
                .execute()
            
            errorMessage = nil
            
            self.firstName = firstName
            self.lastName = lastName
            self.username = username
            
            return true
        } catch {
            print("Error updating profile:", error)
            return false
        }
    }
    
    func updateEmail(_ newEmail: String) async -> Bool {
        guard let userId = sessionManager.userId else { return false }

        let trimmedEmail = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedEmail.isEmpty {
            errorMessage = "Email cannot be empty."
            return false
        }
        
        do {
            try await supabase.auth.update(user: UserAttributes(email: trimmedEmail))
            
            try await supabase
                .from("profile_emails")
                .update(["email": trimmedEmail])
                .eq("id", value: userId)
                .execute()
            
            errorMessage = nil
            
            sessionManager.userEmail = trimmedEmail
            return true
        } catch {
            print("Error updating email:", error)
            if errorMessage == nil {
                errorMessage = "Failed to update email!"
            }
            return false
        }
    }

    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ZStack(alignment: .leading) {
                    Color("Independence").ignoresSafeArea(edges: .top)
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        Text("Your Profile")
                            .font(.system(.title2, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                    .padding(.top, 8)
                }
                .frame(height: bannerHeight)

                ScrollView {
                    VStack(spacing: 36) {
                        InputView(title: "First Name", placeholder: sessionManager.firstName, text: $firstName)
                        InputView(title: "Last Name", placeholder: sessionManager.lastName, text: $lastName)
                        InputView(title: "Username", placeholder: sessionManager.username, text: $username)
                        InputView(title: "Email", placeholder: sessionManager.userEmail, text: $email)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)

                    Button(action: {
                        navigateToForgotPassword = true
                    }) {
                        Text("Reset My Password")
                            .font(.system(size: 16))
                            .foregroundColor(Color("Oxford Blue"))
                            .fontWeight(.semibold)
                            .padding(.top, 20)
                    }
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.top, 5)
                    }

                    Button(action: {
                        Task {
                            let successProfile = await updateProfile(
                                firstName: firstName,
                                lastName: lastName,
                                username: username)
                            
                            let successEmail = await updateEmail(email)
                            
                            if successProfile && successEmail {
                                withAnimation {
                                    showSavedMessage = true
                                }
                                
                                await sessionManager.fetchProfile()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    withAnimation {
                                        showSavedMessage = false
                                        navigateToSettings = true
                                    }
                                }
                            }
                            else {
                                if errorMessage == nil {
                                    errorMessage = "Failed to update profile!"
                                }
                            }
                        }
                    }) {
                        Text("Save")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(Color("Royal Blue"))
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                }
                .frame(maxWidth: .infinity)
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $navigateToForgotPassword) {
                ForgotPasswordView()
            }
            .navigationDestination(isPresented: $navigateToSettings) {
                SettingsView()
            }
            .overlay(
                Group {
                    if showSavedMessage {
                        Text("Profile saved successfully!")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green.opacity(0.9))
                            .cornerRadius(12)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 60)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            )
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
            .environmentObject(SessionManager.preview)
    }
}
