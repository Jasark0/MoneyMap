//
//  SignUpView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI

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

    var body: some View{
        NavigationStack{
            ScrollView{
                VStack{
                    Text("Let's get you set up")
                        
                    
                    VStack(spacing: 18){
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
                            navigateToMain = true
                        }
                    }) {
                        Text("Sign Up")
                            .font(.system(size: 18))
                            .padding(.horizontal, 60)
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
    }
}

#Preview {
    SignUpView()
}

