//
//  SignInView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 20/12/2022.
//

import SwiftUI

struct SignInView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var emailErrorMessage: String = ""
    @State var passwordErrorMessage: String = ""
    
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
        VStack {
            VStack {
                Text("Welcome!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 5)
                Text("Please fill in the fields so we can tailor our services to your account")
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .padding(.bottom, 5)
            }
            .frame(width: 300)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Dark Blue"))
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(Color.white)
                    TextField("Enter your email", text: $email)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(emailErrorMessage)
                        .foregroundColor(Color.red)
                        .font(.caption)
                        .onChange(of: email) { newValue in
                            emailErrorMessage = authVM.validateEmail(email: email)
                        }
                    Text("Password")
                        .foregroundColor(Color.white)
                    SecureField("Enter your password", text: $password)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text(passwordErrorMessage)
                        .foregroundColor(Color.red)
                        .font(.caption)
                        .onChange(of: password) { newValue in
                            passwordErrorMessage = authVM.validatePassword(password: password)
                        }
                }
                .frame(width: 280)
            }
            .frame(maxWidth: .infinity, maxHeight: 250)
            .padding(.horizontal, 20)
            
            Text(authVM.signInStatus)
                .fontWeight(.bold)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color("Dark Blue"))
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                authVM.signIn(email: email, password: password)
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Dark Blue"))
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                    Text("Sign In")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding(.horizontal, 20)
            })
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
