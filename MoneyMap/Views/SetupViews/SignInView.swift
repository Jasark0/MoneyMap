//
//  SignInView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI
import Supabase

struct SignInView: View {
    @State private var username = ""
    @State private var password = ""
    
    @State private var errorMessage: String? = nil
    @State private var navigateToMain = false
    
    
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
                                //await signIn()
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

#Preview {
    SignInView()
}
