//
//  ProfileView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 03/01/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var authVM: AuthVM
    @StateObject var profileVM: ProfileVM
    @EnvironmentObject var firestore: FirestoreHelper
    
    var body: some View {
        VStack {
            HStack {
                Text("My Profile")
                    .fontWeight(.semibold)
                Spacer()
                
                Button {
                    if profileVM.hasUserProfileChanged {
                        profileVM.saveProfileDetailsStatus = ""
                        guard let uid = authVM.auth.currentUser?.uid else {
                            profileVM.saveProfileDetailsStatus = "Your new profile canot be saved as the user ID cannot be retrieved!"
                            return
                        }
                        authVM.updateUserEmail(email: profileVM.email)
                        profileVM.profileUrl = firestore.updateUserEntry(uid: uid, email: profileVM.email, fullname: profileVM.fullname, selectedImage: profileVM.profileImage, profileUrl: profileVM.profileUrl)
                        profileVM.updateProfile()
                        profileVM.saveProfileDetailsStatus = "Your profile was successfully updated"
                    } else {
                        profileVM.saveProfileDetailsStatus = "No changes were made. Consider changing your profile details before saving!"
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("Dark Blue"))
                            .shadow(color: Color.black, radius: 0.1, x: 0, y: 2)
                        if profileVM.hasUserProfileChanged {
                            Text("Save")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                                .font(.caption)
                        } else {
                            Text("Save")
                                .fontWeight(.bold)
                                .foregroundColor(Color.gray)
                                .font(.caption)
                        }
                    }
                    .frame(width: 60)
                }

            }
            .frame(maxHeight: 30)
            .padding(.horizontal, 20)
            
            Button {
                profileVM.showImagePicker.toggle()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(Color("Dark Blue"))
                    if let image = profileVM.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130)
                            .cornerRadius(64)
                    } else {
                        if profileVM.profileUrl.isEmpty {
                            Image(systemName: "person.fill")
                                .font(.system(size: 100))
                                .foregroundColor(Color.white)
                        } else {
                            WebImage(url: URL(string: profileVM.profileUrl))
                                .resizable()
                                .scaledToFill()
                                .frame(width: 130, height: 130)
                                .cornerRadius(64)
                        }
                    }
                }
                .frame(width: 150, height:150)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Dark Blue"))
                    .shadow(color: Color.black, radius: 0.1, x: 0, y: 2)
                VStack(alignment: .leading) {
                    Text("Full Name")
                        .foregroundColor(Color.white)
                    TextField("Enter your fullname", text: $profileVM.fullname)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                    Text(profileVM.fullnameErrorMessage)
                        .font(.caption)
                        .foregroundColor(Color.red)
                        .onChange(of: profileVM.fullname) { newValue in
                            profileVM.fullnameErrorMessage = authVM.validateName(name: newValue)
                        }
                    Text("Email")
                        .foregroundColor(Color.white)
                    TextField("Enter your email", text: $profileVM.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Text(profileVM.emailErrorMessage)
                        .font(.caption)
                        .foregroundColor(Color.red)
                        .onChange(of: profileVM.email) { newValue in
                            profileVM.emailErrorMessage = authVM.validateEmail(email: newValue)
                        }
                    Text("Password")
                        .foregroundColor(Color.white)
                    NavigationLink {
                        EditPasswordView()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Light Blue"))
                                .shadow(color: Color.black, radius: 0.1, x: 0, y: 2)
                            Text("Edit Password")
                                .fontWeight(.semibold)
                                .font(.caption)
                                .foregroundColor(Color.white)
                        }
                        .frame(height: 40)
                    }

                }
                .padding(.horizontal, 20)
            }
            .frame(height: 290)
            .padding(.horizontal, 20)
            
            Text(profileVM.saveProfileDetailsStatus)
                .fontWeight(.bold)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color("Dark Blue"))
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                authVM.signOut()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Dark Blue"))
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                    Text("Sign Out")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.gray)
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
            }
        }
        .fullScreenCover(isPresented: $profileVM.showImagePicker, onDismiss: nil) {
            ImagePicker(selectedImage: $profileVM.profileImage)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileVM: ProfileVM(originalName: "", originalEmail: "", originalProfileUrl: ""))
    }
}
