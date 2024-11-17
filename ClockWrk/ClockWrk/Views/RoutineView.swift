//
//  TaskView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 28/12/2022.
//

import SwiftUI

struct RoutineView: View {
    
    @EnvironmentObject var firestore: FirestoreHelper
    @StateObject var routineVM = RoutineVM()
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round))
                TextField("Search routines", text: $routineVM.search)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(5)
            }
            .frame(maxWidth: .infinity, maxHeight: 30)
            .padding(.horizontal, 20)
            
            ZStack(alignment: .bottomTrailing) {
                List {
                    if routineVM.isSearchEnabled {
                        ForEach(firestore.routineData.filter({ UserRoutine in
                            UserRoutine.title.contains(routineVM.search)
                        })) { routine in
                            routineSubView(routineSubVM: RoutineSubVM(name: routine.title, description: routine.description, startTime: routine.startTime, endTime: routine.endTime))
                        }
                    } else {
                        ForEach(firestore.routineData) { routine in
                            routineSubView(routineSubVM: RoutineSubVM(name: routine.title, description: routine.description, startTime: routine.startTime, endTime: routine.endTime))
                        }
                    }
                }
                .clipped()
                
                NavigationLink(destination: AddRoutineView()) {
                    addRoutineButton()
                }
                .padding(.horizontal, 20)
            }
        }
        .frame(alignment: .top)
    }
}

struct routineSubView: View {
    
    @StateObject var routineSubVM: RoutineSubVM
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Dark Blue"))
                .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
            VStack(alignment: .leading) {
                Text(routineSubVM.name)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .font(.title)
                
                Text("Description")
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
                    .font(.caption)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Light Blue"))
                    Text(routineSubVM.description)
                        .foregroundColor(Color.white)
                        .font(.caption)
                        .padding(.horizontal, 10)
                }
                .frame(height: 30)
                
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text("Start Time")
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .font(.caption)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Light Blue"))
                            Text(routineSubVM.startDateTime, style: .time)
                                .foregroundColor(Color.white)
                                .font(.caption)
                                .padding(.horizontal, 10)
                        }
                        .frame(height: 30, alignment: .center)
                    }
                    .frame(width: 130)
                    
                    VStack(alignment: .leading) {
                        Text("End Time")
                            .foregroundColor(Color.white)
                            .fontWeight(.semibold)
                            .font(.caption)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Light Blue"))
                            Text(routineSubVM.endDateTime, style: .time)
                                .foregroundColor(Color.white)
                                .font(.caption)
                                .padding(.horizontal, 10)
                        }
                        .frame(height: 30, alignment: .center)
                    }
                    .frame(width: 130)
                }
                .frame(maxWidth: .infinity)
                
                NavigationLink(destination: EditRoutineView(editRoutineVM: EditRoutineVM(title: routineSubVM.name, description: routineSubVM.description, startTime: routineSubVM.startTime, endTime: routineSubVM.endTime))) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("Light Blue"))
                            .shadow(color: Color.black, radius: 0.1, x: 0, y: 2)
                        Text("Edit Routine")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .font(.caption)
                    }
                    .frame(height: 30)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 20)
        }
        .frame(height: 230)
    }
}

/*struct routineSubView_Previews: PreviewProvider {
    static var previews: some View {
        routineSubView()
    }
}
 */

struct RoutineView_Previews: PreviewProvider {
    static var previews: some View {
        RoutineView()
    }
}
