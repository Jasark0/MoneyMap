import SwiftUI

struct GetStartedView: View {
    @EnvironmentObject var sessionManger: SessionManager
    
    var body: some View {
        NavigationStack{
            VStack{
                Image("MoneyMapLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                NavigationLink(destination: SignUpView().environmentObject(sessionManger)){
                    Text("Get Started  >>>")
                        .font(.system(size: 18))
                        .padding(.horizontal, 100)
                        .padding(.vertical, 20)	
                        .foregroundColor(.white)
                        .background(Color("Oxford Blue"))
                        .cornerRadius(15)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
        }
    }
}

#Preview {
    GetStartedView()
}
