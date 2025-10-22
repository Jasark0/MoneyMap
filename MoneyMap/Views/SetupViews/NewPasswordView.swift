import SwiftUI

struct NewPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var navigateToSignIn = false
    @State private var showPasswordWarning = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer(minLength: 250)
                        
                        Text("Create New Password")
                            .font(.system(size: 28))
                            .padding(.bottom, 10)
                        
                        VStack(spacing: 25) {
                            SecureInputView(title: "New Password", text: $newPassword)
                            SecureInputView(title: "Confirm New Password", text: $confirmPassword)
                        }
                        .padding(.horizontal, 30)
                        
                        if showPasswordWarning {
                            Text("Passwords do not match.")
                                .foregroundColor(.red)
                                .font(.subheadline)
                                .padding(.top, 5)
                        }
                        
                        Button(action: {
                            if newPassword != confirmPassword {
                                showPasswordWarning = true
                            } else {
                                showPasswordWarning = false
                                navigateToSignIn = true
                            }
                        }) {
                            Text("Create New Password")
                                .font(.system(size: 18))
                                .padding(.horizontal, 80)
                                .padding(.vertical, 20)
                                .foregroundColor(.white)
                                .background(Color("Oxford Blue"))
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 60)
                    }
                    .frame(maxWidth: .infinity)
                    .navigationDestination(isPresented: $navigateToSignIn) {
                        SignInView()
                    }
                }
            }
            
            HStack {
                Text("Remembered your password?")
                    .foregroundColor(.gray)
                
                NavigationLink(destination: SignInView()) {
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
    NavigationStack {
        NewPasswordView()
    }
}
