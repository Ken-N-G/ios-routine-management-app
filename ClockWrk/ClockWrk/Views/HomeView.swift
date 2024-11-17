//
//  HomeView().swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 28/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    @EnvironmentObject var authVM: AuthVM
    @EnvironmentObject var firestore: FirestoreHelper
    @StateObject var homeVM = HomeVM()
    
    var body: some View {
        VStack(alignment: .trailing){
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Dark Blue"))
                    .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                VStack {
                    VStack(alignment: .leading) {
                        Text(homeVM.routineName)
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .font(.title)
                            .padding(.top, 20)
                        Spacer()
                        Text("Description")
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Light Blue"))
                            Text(homeVM.routineDescription)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.leading)
                                .padding(.horizontal)
                        }
                        .frame(height: 65)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Start Time")
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("Light Blue"))
                                Text(homeVM.startTime)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .frame(width: 145, height: 70)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("End Time")
                                .foregroundColor(Color.white)
                                .fontWeight(.semibold)
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color("Light Blue"))
                                Text(homeVM.endTime)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .frame(width: 145, height: 70)
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal, .bottom], 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 450)
            .padding(.horizontal, 20)
            
            Spacer()
            
            NavigationLink(destination: AddRoutineView(), label: {
                addRoutineButton()
            })
                .padding(.trailing, 20)
        }.onAppear {
            homeVM.toggleTimer()
        }.onReceive(homeVM.timer) { output in
            homeVM.updateTasks(userRoutines: firestore.routineData)
            homeVM.checkCurrentTask(currentTime: output)
            homeVM.displayRoutine()
        }.onDisappear {
            homeVM.toggleTimer()
        }
    }
}

struct addRoutineButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Light Blue"))
                .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Dark Blue"))
                .frame(width: 12, height: 60)
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Dark Blue"))
                .frame(width: 60, height: 12)
        }
        .frame(width: 90, height: 90, alignment: .center)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
