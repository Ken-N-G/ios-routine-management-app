//
//  EditPasswordView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 03/01/2023.
//

import SwiftUI

struct EditPasswordView: View {
    
    @EnvironmentObject var authVM: AuthVM
    @EnvironmentObject var firestore: FirestoreHelper
    @StateObject var editPasswordVM = EditPasswordVM()
    
    @State var newPasswordErrorMessage: String = ""
    @State var confirmPasswordErrorMessage: String = ""
    @State var passwordChangeStatus: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Edit Password")
                .fontWeight(.semibold)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Dark Blue"))
                VStack(alignment: .leading) {
                    Text("New Password")
                        .foregroundColor(Color.white)
                    SecureField("Enter your new password", text: $editPasswordVM.newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Text(newPasswordErrorMessage)
                        .font(.caption)
                        .foregroundColor(Color.red)
                        .onChange(of: editPasswordVM.newPassword) { newValue in
                            newPasswordErrorMessage = authVM.validatePassword(password: newValue)
                        }
                    Text("Confirm Password")
                        .foregroundColor(Color.white)
                    SecureField("Enter your email", text: $editPasswordVM.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Text(confirmPasswordErrorMessage)
                        .font(.caption)
                        .foregroundColor(Color.red)
                        .onChange(of: editPasswordVM.confirmPassword) { newValue in
                            confirmPasswordErrorMessage = authVM.validateConfirmPassword(password: editPasswordVM.newPassword, confirmPassword: newValue)
                        }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 200)
            
            Text(passwordChangeStatus)
            
            Spacer()
            
            Button {
                passwordChangeStatus = ""
                guard editPasswordVM.areFieldsComplete else {
                    passwordChangeStatus = "Fill in both fields before saving!"
                    return
                }
                authVM.updateUserPassword(password: editPasswordVM.newPassword, confirmPassword: editPasswordVM.confirmPassword)
                passwordChangeStatus = authVM.updatePasswordStatus
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Dark Blue"))
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                    Text("Save Password")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                }
                .frame(height: 50)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct EditPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        EditPasswordView()
    }
}
