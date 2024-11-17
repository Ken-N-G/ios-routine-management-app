//
//  AddRoutineView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 28/12/2022.
//

import SwiftUI

struct AddRoutineView: View {
    @EnvironmentObject var authVM: AuthVM
    @EnvironmentObject var firestore: FirestoreHelper
    @StateObject var addRoutineVM = AddRoutineVM()
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Add your routine information")
                .fontWeight(.semibold)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Dark Blue"))
                VStack(alignment: .leading) {
                    Text("Routine Name")
                        .foregroundColor(Color.white)
                    TextField("Enter your Routine's name", text: $addRoutineVM.routineName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Text(addRoutineVM.nameErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                            .onChange(of: addRoutineVM.routineName) { newValue in
                                addRoutineVM.checkNameAvailability(routines: firestore.routineData)
                            }
                        Spacer()
                        Text("\(addRoutineVM.routineName.count)/15")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                    Text("Routine Description")
                        .foregroundColor(Color.white)
                    TextField("Enter your Routine's description", text: $addRoutineVM.routineDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Text(addRoutineVM.descriptionErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                        Spacer()
                        Text("\(addRoutineVM.routineDescription.count)/30")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                    VStack(alignment: .leading) {
                        Text("Start Time")
                            .foregroundColor(Color.white)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            DatePicker("", selection: $addRoutineVM.startingDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .onChange(of: addRoutineVM.startingDate) { newValue in
                                    addRoutineVM.validateDates(routineData: firestore.routineData)
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        Text(addRoutineVM.dateErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                        Text("End Time")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            DatePicker("", selection: $addRoutineVM.endingDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .onChange(of: addRoutineVM.endingDate) { newValue in
                                    addRoutineVM.validateDates(routineData: firestore.routineData)
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        Text(addRoutineVM.dateErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 370)
            
            Text(addRoutineVM.routineErrorMessage)
                .fontWeight(.bold)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color("Dark Blue"))
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                addRoutineVM.routineErrorMessage = ""
                addRoutineVM.checkNameAvailability(routines: firestore.routineData)
                addRoutineVM.validateFields()
                addRoutineVM.validateDates(routineData: firestore.routineData)
                guard addRoutineVM.isRoutineValid, !addRoutineVM.routineName.isEmpty, !addRoutineVM.routineDescription.isEmpty, addRoutineVM.startingDate < addRoutineVM.endingDate else {
                    addRoutineVM.routineErrorMessage = "Some fields are empty or have invalid inputs! Fill them up or change them first before trying again"
                    return
                }
                addRoutineVM.convertDateToTouple()
                firestore.appendNewRoutine(uid: authVM.auth.currentUser?.uid ?? "", title: addRoutineVM.routineName, description: addRoutineVM.routineDescription, startTime: addRoutineVM.startTime, endTime: addRoutineVM.endTime)
                firestore.storeRoutineEntry(uid: authVM.auth.currentUser?.uid ?? "", routine: firestore.routineData.last ?? UserRoutine())
                addRoutineVM.routineErrorMessage = "Your routine was successfully created!"
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Dark Blue"))
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                    Text("Create Routine")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(addRoutineVM.createRoutine)
                        .onChange(of: addRoutineVM.isRoutineValid) { newValue in
                            if newValue == true {
                                addRoutineVM.createRoutine = Color.white
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
            }

        }
        .padding(.horizontal, 20)
    }
}

struct AddRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        AddRoutineView()
    }
}
