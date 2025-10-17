//
//  SignInView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI
import Supabase

struct SignInView: View {
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var username = ""
    @State private var password = ""
    
    @State private var errorMessage: String? = nil
    @State private var navigateToMain = false
    
    struct Profile: Decodable {
        let id: UUID
    }
    
    struct EmailProfile: Decodable {
        let email: String
    }

    func getEmail(for id: UUID) async -> String?{
        do {
            let emailData: [EmailProfile] = try await supabase
                .from("profile_emails")
                .select("email")
                .eq("id", value: id)
                .execute()
                .value
            
            if let emailProfile = emailData.first {
                return emailProfile.email
            }
            else {
                print("No email found for this ID")
                return nil
            }
        }
        catch {
            print("Error fetching email: \(error)")
            return nil
        }
    }
    
    func signIn() async {
        do {
            errorMessage = nil
            
            let profiles: [Profile] = try await supabase
                .from("profiles")
                .select("id")
                .eq("username", value: username)
                .execute()
                .value
        
            if let profile = profiles.first {
                if let email = await getEmail(for: profile.id) {
                    try await supabase.auth.signIn(
                        email: email,
                        password: password
                    )
                    
                    // Store user ID in session manager
                    sessionManager.setUser(id: profile.id)

                    
                    navigateToMain = true
                }
                else {
                    print("Could not retrieve email for user.")
                }
            }
            else {
                print("No profile found for username \(username)")
            }
        }
        catch {
            print("Error during sign-in: \(error)")
        }
    }


    var body: some View {
        NavigationStack{
            ZStack{
                ScrollView{
                    VStack(spacing: 15){
                        Image("MoneyMapLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding(.top, 30)
                        
                        VStack(spacing: 18){
                            InputView(title: "Username", text: $username)
                            SecureInputView(title: "Password", text: $password)
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer()
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 5)
                        }
                        
                        Button(action: {
                            Task{
                                await signIn()
                            }
                        }) {
                            Text("Sign In")
                                .font(.system(size: 18))
                                .padding(.horizontal, 100)
                                .padding(.vertical, 20)
                                .foregroundColor(.white)
                                .background(Color("Oxford Blue"))
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)
                        
                        NavigationLink(destination: ForgotPasswordView()){
                            Text("Forgot password?")
                                .foregroundColor(Color("Oxford Blue"))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .navigationDestination(isPresented: $navigateToMain) {
                        MainView()
                    }
                }
            }
            
            HStack{
                Text("Don't have an account?")
                    .foregroundColor(.gray)
                    
                NavigationLink(destination: SignUpView()){
                    Text("Sign Up")
                        .foregroundColor(Color("Oxford Blue"))
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 15)
        }
        .navigationBarBackButtonHidden(true)
    }
}

//PREVIEW NOT WORKING!
#Preview {
    NavigationStack {
        SignInView()
    }
    .environmentObject(SessionManager.preview)
}

