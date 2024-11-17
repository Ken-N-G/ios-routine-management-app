//
//  AuthViewModel.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 23/12/2022.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthVM: ObservableObject {
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    @Published var registerStatus: String = ""
    @Published var signInStatus: String = ""
    @Published var updatePasswordStatus: String = ""
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        signInStatus = ""
        guard !email.isEmpty, !password.isEmpty else {
            signInStatus = "Some fields are empty!"
            return
        }
        auth.signIn(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.signInStatus = "Failed to sign in user! Error message: \(error?.localizedDescription ?? "Something went wrong")"
                return
            }
            self?.signInStatus = "Success!"
            DispatchQueue.main.async {
                self?.signedIn = true
                self?.signInStatus = ""
            }
        }
    }
    
    func register(email: String, password: String, confirmPassword: String, fullName: String, pUrl: String) {
        registerStatus = ""
        guard !email.isEmpty, !password.isEmpty, confirmPassword == password, !fullName.isEmpty else {
            registerStatus = "Some fields are empty or your passwords do not match!"
            return
        }
        auth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard result != nil, error == nil else {
                self?.registerStatus = "Failed to register user! Error message: \(error?.localizedDescription ?? "Something went wrong")"
                return
            }
            self?.registerStatus = "Success!"
            DispatchQueue.main.async {
                self?.signedIn = true
                guard let uid = self?.auth.currentUser?.uid else {
                    return
                }
                let userData = ["uid": uid, "fullname": fullName, "email": email, "profileUrl": pUrl]
                Firestore.firestore().collection("users").document(uid).setData(userData) { error in
                    if let error = error {
                        print("Cannot create user entry with uid: \(uid) Error \(error)")
                        return
                    }
                    print("Success")
                }
                self?.registerStatus = ""
            }
        }
    }
    
    func updateUserEmail(email: String) {
        auth.currentUser?.updateEmail(to: email, completion: { error in
            if let error = error {
                print("Cannot update the email of user entry with uid: \(self.auth.currentUser?.uid ?? "Cannot retrieve uid") Error: \(error)")
                return
            }
            print("Success")
        })
    }
    
    func updateUserPassword(password: String, confirmPassword: String) {
        updatePasswordStatus = ""
        guard password == confirmPassword else {
            updatePasswordStatus = "Your passwords do not match!"
            return
        }
        auth.currentUser?.updatePassword(to: password, completion: { error in
            if let error = error {
                print("Cannot update the password of user entry with uid: \(self.auth.currentUser?.uid ?? "Cannot retrieve uid") Error: \(error)")
                self.updatePasswordStatus = "Cannot update password of this user! Error message: \(error)"
                return
            }
            print("Success")
        })
        updatePasswordStatus = "Password was successfully updated"
    }
    
    func validatePassword(password: String) -> String {
        guard !password.isEmpty else {
            return "The password field cannot be empty!"
        }
        if password.count < 6 {
            return "The password cannot be less than 6 characters"
        } else {
            return ""
        }
    }
    
    func validateConfirmPassword(password: String, confirmPassword: String) -> String {
        guard !confirmPassword.isEmpty else {
            return "Your re-entered password cannot be empty"
        }
        if confirmPassword.count < 6 {
            return "Your re-entered cannot be less than 6 characters"
        } else if password != confirmPassword {
            return "Your re-entered password does not match"
        } else {
            return ""
        }
    }
    
    func validateEmail(email: String) -> String {
        guard !email.isEmpty else {
            return "The email field cannot be empty!"
        }
        return ""
    }
    
    func validateName(name: String) -> String {
        guard !name.isEmpty else {
            return "The fullname field cannot be empty!"
        }
        return ""
    }
    
    func signOut() {
        try? auth.signOut()
        
        self.signedIn = false
    }
}
