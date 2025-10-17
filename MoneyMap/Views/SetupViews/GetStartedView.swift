//
//  GetStartedView.swift
//  MoneyMap
//
//  Created by user279040 on 10/6/25.
//

import SwiftUI

struct GetStartedView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Image("MoneyMapLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 350)
                NavigationLink(destination: SignUpView()){
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
