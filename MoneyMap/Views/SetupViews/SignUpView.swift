import SwiftUI
import Supabase

struct SignUpView: View{
    @EnvironmentObject var sessionManager: SessionManager
    
    @State private var userId: UUID? = nil
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    //Check if password is identical to confirmPassword
    @State private var showPasswordWarning = false
    @State private var errorMessage: String? = nil
    @State private var navigateToSetup = false
    
    struct Profile: Encodable {
        let id: String
        let username: String
        let first_name: String
        let last_name: String
    }
    
    struct UsernameCheck: Decodable {
        let id: String
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    func signUp() async {
        guard isValidEmail(email) else {
            errorMessage = "Invalid email format."
            return
        }
        
        guard username.count >= 6 else {
            errorMessage = "Username must be at least 6 characters."
            return
        }
        
        guard password.count >= 8 else {
            errorMessage = "Password must be at least 8 characters."
            return
        }
        
        do {
            do {
                let usernameResult: [UsernameCheck] = try await supabase
                    .from("profiles")
                    .select("id")
                    .eq("username", value: username)
                    .execute()
                    .value
                
                if !usernameResult.isEmpty {
                    errorMessage = "Username already exists!"
                    return
                }
            } catch {
                errorMessage = "Failed to check username availability."
                return
            }

            
            let response = try await supabase.auth.signUp(email: email, password: password)
            
            let newUser = response.user
            userId = newUser.id
            
            let profile = Profile(
                id: newUser.id.uuidString,
                username: username,
                first_name: firstName,
                last_name: lastName
            )
            
            do {
                try await supabase
                    .from("profiles")
                    .insert(profile)
                    .execute()
                
                sessionManager.userId = newUser.id
                
                navigateToSetup = true
                
            } catch {
                print("Profile insert error:", error)
                errorMessage = " Username already exists!"
            }
            
        }
        catch {
            errorMessage = "Email already exists!"
        }
    }

    var body: some View{
        NavigationStack{
            ZStack{
                ScrollView{
                    VStack{
                        Text("Let's get you set up!")
                            .font(.system(size: 28))
                            .padding(.top, 45)
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
                        
                        if let error = errorMessage {
                            Text(error)
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
                    .navigationDestination(isPresented: $navigateToSetup) {
                        if let id = userId {
                            SetupView(userId: id)
                                .environmentObject(sessionManager)
                        }
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
    NavigationStack {
        SignUpView()
    }
    .environmentObject(SessionManager.preview)
}




