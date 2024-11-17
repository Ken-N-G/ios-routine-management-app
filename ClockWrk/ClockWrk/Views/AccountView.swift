//
//  AccountView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 28/12/2022.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var authVM: AuthVM
    @EnvironmentObject var firestore: FirestoreHelper
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Text("My Account")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    NavigationLink(destination: ProfileView(profileVM: ProfileVM(originalName: firestore.userData.fullname, originalEmail: firestore.userData.email, originalProfileUrl: firestore.userData.profileUrl))) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("Dark Blue"))
                                .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                            HStack {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .foregroundColor(Color.white)
                                    .frame(width: 35, height: 35)
                                    .padding(.horizontal, 20)
                                VStack(alignment: .leading) {
                                    Text("Edit Profile")
                                        .font(.title2)
                                        .foregroundColor(Color.white)
                                    Rectangle()
                                        .frame(height: 1)
                                }
                                .frame(width: 200)
                                Image(systemName: "arrow.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding()
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
        }
        .clipped()
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
