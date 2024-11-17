//
//  HomeView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 23/12/2022.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var authVM: AuthVM
    @EnvironmentObject var firestore: FirestoreHelper
    
    enum Screen: String {
        case Home
        case Routines
        case Account
    }

    @State var currentScreen: Screen = .Home
    
    var body: some View {
        NavigationView {
            TabView(selection: $currentScreen) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                    .tag(Screen.Home)
                RoutineView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("Routines")
                    }
                    .tag(Screen.Routines)
                AccountView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Account")
                    }
                    .tag(Screen.Account)
            }
            .accentColor(Color.black)
            .navigationTitle(currentScreen.rawValue)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(FirestoreHelper(uid: ""))
    }
}
