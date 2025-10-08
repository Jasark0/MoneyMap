//
//  SignUpView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI
import Supabase

struct SignUpView: View{
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    //Check if password is identical to confirmPassword
    @State private var showPasswordWarning = false
    @State private var navigateToMain = false
    
    struct Profile: Encodable {
        let id: String
        let username: String
        let first_name: String
        let last_name: String
    }

    func signUp() async {
        do{
            let response = try await supabase.auth.signUp(email: email, password: password)
            let userId = response.user.id
            
            print("User created successfully: \(response.user.email ?? "Unknown email")")
            
            let profile = Profile(
                id: userId.uuidString,
                username: username,
                first_name: firstName,
                last_name: lastName
            )
            
            try await supabase.from("profiles").insert(profile).execute()
            
            print("Profile inserted successfully for user \(username)")
            
            navigateToMain = true
        }
        catch{
            print("Error during signup: \(error.localizedDescription)")
        }
    }


    var body: some View{
        NavigationStack{
            ZStack{
                ScrollView{
                    VStack{
                        Text("Let's get you set up")
                            .font(.system(size: 28))
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                        
                        
                        VStack(spacing: 25){
                            InputView(title: "First Name", text: $firstName)
                            InputView(title: "Last Name", text: $lastName)
                            InputView(title: "Username", text: $username)
                            InputView(title: "Email", text: $email)
                            SecureInputView(title: "Password", text: $password)
                            SecureInputView(title: "Confirm Password", text: $confirmPassword)
                        }
                        .padding(.horizontal, 30)
                        
                        if (showPasswordWarning){
                            Text("Passwords do not match.")
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 5)
                        }
                        
                        Button(action: {
                            if (password != confirmPassword){
                                showPasswordWarning = true
                            }
                            else{
                                showPasswordWarning = false
                                Task{
                                    await signUp()
                                }
                            }
                        }) {
                            Text("Sign Up")
                                .font(.system(size: 18))
                                .padding(.horizontal, 100)
                                .padding(.vertical, 20)
                                .foregroundColor(.white)
                                .background(Color("Oxford Blue"))
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .navigationDestination(isPresented: $navigateToMain) {
                        MainView()
                    }
                }
            }
            
            HStack{
                Text("Already have an account?")
                    .foregroundColor(.gray)
                    
                NavigationLink(destination: SignInView()){
                    Text("Sign In")
                        .foregroundColor(Color("Oxford Blue"))
                        .fontWeight(.semibold)
                }
            }
            .padding(.top, 15)
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SignUpView()
}

