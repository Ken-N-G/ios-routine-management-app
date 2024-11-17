//
//  OnboardView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 20/12/2022.
//

import SwiftUI

struct OnboardView: View {
    
    @EnvironmentObject var authVM: AuthVM
    
    var body: some View {
        if authVM.signedIn {
            MainView()
                .environmentObject(FirestoreHelper(uid: authVM.auth.currentUser?.uid ?? ""))
        } else {
            NavigationView{
                GeometryReader{ geometry in
                    VStack{
                        Image("journey")
                            .resizable()
                            .frame(height: geometry.size.height/2)
                            .clipped()
                            .padding(.bottom, 5)
                        Text("Start Scheduling with ClockWrk")
                            .font(.headline.bold())
                            .padding(.bottom, 5)
                        Text("Begin your scheduling journey with ClockWrk. Plan your week and get into routines with a simple press of a button")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: 70)
                            .padding(.horizontal, 20)
                        
                        Spacer()
                        NavigationLink(destination: RegisterView()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("Dark Blue"))
                                    .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                                Text("Get Started")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .padding(.horizontal, 20)
                        }
                        
                        NavigationLink("Have an account? Sign-In ->", destination: SignInView())
                    }
                }
                .navigationTitle("Get Started")
            }
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}
