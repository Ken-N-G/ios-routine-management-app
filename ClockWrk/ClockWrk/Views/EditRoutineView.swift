//
//  EditRoutineView.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 05/01/2023.
//

import SwiftUI

struct EditRoutineView: View {
    @EnvironmentObject var authVM: AuthVM
    @EnvironmentObject var firestore: FirestoreHelper
    @StateObject var editRoutineVM: EditRoutineVM
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Edit your routine information")
                .fontWeight(.semibold)
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("Dark Blue"))
                VStack(alignment: .leading) {
                    Text("Routine Name")
                        .foregroundColor(Color.white)
                    TextField("Enter your Routine's name", text: $editRoutineVM.routineName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Text(editRoutineVM.nameErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                            .onChange(of: editRoutineVM.routineName) { newValue in
                                editRoutineVM.checkNameAvailability(routines: firestore.routineData)
                            }
                        Spacer()
                        Text("\(editRoutineVM.routineName.count)/15")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                    Text("Routine Description")
                        .foregroundColor(Color.white)
                    TextField("Enter your Routine's description", text: $editRoutineVM.routineDescription)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    HStack {
                        Text(editRoutineVM.descriptionErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                        Spacer()
                        Text("\(editRoutineVM.routineDescription.count)/30")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                    VStack(alignment: .leading) {
                        Text("Start Time")
                            .foregroundColor(Color.white)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            DatePicker("", selection: $editRoutineVM.startingDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .onChange(of: editRoutineVM.startingDate) { newValue in
                                    editRoutineVM.validateDates(routineData: firestore.routineData)
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        Text(editRoutineVM.dateErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                        Text("End Time")
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.white)
                            DatePicker("", selection: $editRoutineVM.endingDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .onChange(of: editRoutineVM.endingDate) { newValue in
                                    editRoutineVM.validateDates(routineData: firestore.routineData)
                                }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 40)
                        Text(editRoutineVM.dateErrorMessage)
                            .font(.caption)
                            .foregroundColor(Color.red)
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 370)
            
            Text(editRoutineVM.routineErrorMessage)
                .fontWeight(.bold)
                .font(.caption)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(Color("Dark Blue"))
                .frame(maxWidth: .infinity, maxHeight: 100)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button {
                editRoutineVM.routineErrorMessage = ""
                editRoutineVM.checkNameAvailability(routines: firestore.routineData)
                editRoutineVM.validateFields()
                editRoutineVM.validateDates(routineData: firestore.routineData)
                guard editRoutineVM.isRoutineValid, !editRoutineVM.routineName.isEmpty, !editRoutineVM.routineDescription.isEmpty, editRoutineVM.startingDate < editRoutineVM.endingDate else {
                    editRoutineVM.routineErrorMessage = "Some fields are empty or have invalid inputs! Fill them up or change them first before trying again"
                    return
                }
                editRoutineVM.convertDateToTouple()
                firestore.updateRoutine(oldTitle: editRoutineVM.oldTitle, uid: authVM.auth.currentUser?.uid ?? "", newTitle: editRoutineVM.routineName , newDescription: editRoutineVM.routineDescription, newStartTime: editRoutineVM.startTime, newEndTime: editRoutineVM.endTime)
                firestore.updateRoutineEntry(uid: authVM.auth.currentUser?.uid ?? "", oldTitle: editRoutineVM.oldTitle, newTitle: editRoutineVM.routineName)
                editRoutineVM.routineErrorMessage = "Your routine was successfully changed!"
                editRoutineVM.changeTitles()
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("Dark Blue"))
                        .shadow(color: Color.gray, radius: 2, x: 0, y: 4)
                    Text("Save Changes")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(editRoutineVM.createRoutine)
                        .onChange(of: editRoutineVM.isRoutineValid) { newValue in
                            if newValue == true {
                                editRoutineVM.createRoutine = Color.white
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
            }

        }
        .padding(.horizontal, 20)
    }
}

struct EditRoutineView_Previews: PreviewProvider {
    static var previews: some View {
        EditRoutineView(editRoutineVM: EditRoutineVM(title: "", description: "", startTime: (0, 0), endTime: (0, 0)))
    }
}
