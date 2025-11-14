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
                errorMessage = "Username not found!"
                return nil
            }
        }
        catch {
            errorMessage = "Username not found!"
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
                    
                    sessionManager.signIn(id: profile.id)
                    
                    navigateToMain = true
                }
                else {
                    errorMessage = "Incorrect username/password!"
                }
            }
            else {
                errorMessage = "Incorrect username/password!"
            }
        }
        catch {
            errorMessage = "Incorrect username/password!"
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
            .navigationDestination(isPresented: $navigateToMain) {
                MainShellView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    NavigationStack {
        SignInView()
    }
    .environmentObject(SessionManager.preview)
}

