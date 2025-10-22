import SwiftUI

struct ForgotPasswordView: View {
    @State private var email: String = ""
    @State private var navigateToNewPassword = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack {
                        Spacer(minLength: 250)
                        
                        Text("Reset Password")
                            .font(.system(size: 28))
                            .padding(.bottom, 10)
                        
                        Text("Enter your email to reset your password.")
                            .fontWeight(.light)
                            .foregroundColor(.gray)
                            .padding(.bottom, 30)
                        
                        VStack(spacing: 25) {
                            InputView(title: "Email", text: $email)
                        }
                        .padding(.horizontal, 30)
                        
                        Spacer(minLength: 50)
                        
                        Button(action: {
                            navigateToNewPassword = true
                        }) {
                            Text("Next")
                                .font(.system(size: 18))
                                .padding(.horizontal, 100)
                                .padding(.vertical, 20)
                                .foregroundColor(.white)
                                .background(Color("Oxford Blue"))
                                .cornerRadius(15)
                        }
                        .padding(.top, 20)
                        
                        Spacer(minLength: 60) // adds some breathing room above footer
                    }
                    .frame(maxWidth: .infinity)
                    .navigationDestination(isPresented: $navigateToNewPassword) {
                        NewPasswordView()
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
    }
}

#Preview {
    NavigationStack {
        ForgotPasswordView()
    }
}
