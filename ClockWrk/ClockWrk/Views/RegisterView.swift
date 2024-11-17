//
//  RegisterView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 20/12/2022.
//

import SwiftUI

struct RegisterView: View {
    
    @State var fullName: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var nameErrorMessage: String = ""
    @State var emailErrorMessage: String = ""
    @State var passwordErrorMessage: String = ""
    @State var confirmPasswordErrorMessage: String = ""
    
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
            VStack {
                VStack {
                    Text("Before you begin...")
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
                    VStack {
                        VStack (alignment: .leading) {
                            Text("Full Name")
                                .foregroundColor(Color.white)
                            TextField("Enter your full name", text: $fullName)
                                .disableAutocorrection(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text(nameErrorMessage)
                                .foregroundColor(Color.red)
                                .font(.caption)
                                .onChange(of: fullName) { newValue in
                                    nameErrorMessage = authVM.validateName(name: fullName)
                                }
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
                        }
                        VStack (alignment: .leading) {
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
                            Text("Confirm Password")
                                .foregroundColor(Color.white)
                            SecureField("Re-enter your password", text: $confirmPassword)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Text(confirmPasswordErrorMessage)
                                .foregroundColor(Color.red)
                                .font(.caption)
                                .onChange(of: confirmPassword) { newValue in
                                    confirmPasswordErrorMessage = authVM.validateConfirmPassword(password: password, confirmPassword: confirmPassword)
                                }
                        }
                    }
                    .frame(width: 280)
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
                .padding(.horizontal, 20)
                
                Text(authVM.registerStatus)
                    .fontWeight(.bold)
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(Color("Dark Blue"))
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .padding(.horizontal, 20)
                
                Spacer()
                
                Button(action: {
                    authVM.register(email: email, password: password, confirmPassword: confirmPassword, fullName: fullName, pUrl: "")
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("Dark Blue"))
                            .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                        Text("Register")
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

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
