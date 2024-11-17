//
//  ContentView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 23/12/2022.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        NavigationView {
            if authVM.isSignedIn {
                HomeView()
            }
            else {
                OnboardView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
