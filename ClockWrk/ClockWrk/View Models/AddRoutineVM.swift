//
//  AddRoutineVM.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 04/01/2023.
//

import Foundation
import SwiftUI

class AddRoutineVM: ObservableObject {
    
    @Published var routineName: String = "" {
        didSet { validateRoutineName()
            routineErrorMessage = ""
        }
    }
    @Published var routineDescription: String = "" {
        didSet { validateRoutineDescription()
            routineErrorMessage = ""
        }
    }
    @Published var startTimeDisplay: String = "Choose a start time"
    @Published var endTimeDisplay: String = "Choose an end time"
    @Published var startTime: (Int, Int) = (0, 0)
    @Published var endTime: (Int, Int) = (0, 0)
    @Published var isRoutineValid: Bool = false {
        didSet { if isRoutineValid { createRoutine = Color.white } else { createRoutine = Color.gray }
            routineErrorMessage = ""
        }
    }
    @Published var createRoutine: Color = Color.gray
    @Published var routineErrorMessage: String = ""
    @Published var nameErrorMessage: String = "" {
        didSet { if nameErrorMessage.isEmpty && descriptionErrorMessage.isEmpty && dateErrorMessage.isEmpty { isRoutineValid = true } else { isRoutineValid = false } }
    }
    @Published var descriptionErrorMessage: String = "" {
        didSet { if nameErrorMessage.isEmpty && descriptionErrorMessage.isEmpty && dateErrorMessage.isEmpty { isRoutineValid = true } else { isRoutineValid = false } }
    }
    @Published var startingDate: Date = Date()
    @Published var endingDate: Date = Date()
    @Published var dateErrorMessage: String = "" {
        didSet { if nameErrorMessage.isEmpty && descriptionErrorMessage.isEmpty && dateErrorMessage.isEmpty { isRoutineValid = true } else { isRoutineValid = false } }
    }
    
    func convertDateToTouple() {
        startTime = (Calendar.current.component(.hour, from:startingDate), Calendar.current.component(.minute, from: startingDate))
        endTime = (Calendar.current.component(.hour, from:endingDate), Calendar.current.component(.minute, from: endingDate))
    }
    
    func validateFields() {
        validateRoutineName()
        validateRoutineDescription()
    }
    
    func validateRoutineName() {
        guard routineName.count > 0 else {
            nameErrorMessage = "Routine name cannot be empty!"
            return
        }
        guard routineName.count < 16 else {
            nameErrorMessage = "Routine name cannot exceed 25 characters!"
            return
        }
        nameErrorMessage = ""
    }
    
    func checkNameAvailability(routines: [UserRoutine]) {
        for routine in routines {
            guard routine.title != routineName else {
                nameErrorMessage = "There is an existing routine with this name!"
                return
            }
        }
    }
    
    func validateRoutineDescription() {
        guard routineDescription.count > 0 else {
            descriptionErrorMessage = "Routine description cannot be empty!"
            return
        }
        guard routineDescription.count < 31 else {
            descriptionErrorMessage = "Routine description cannot exceed 50 characters!"
            return
        }
        descriptionErrorMessage = ""
    }
    
    func validateDates(routineData: [UserRoutine]) {
        convertDateToTouple()
        guard startTime < endTime else {
            dateErrorMessage = "Start time cannot be less or equal to the end time!"
            return
        }
        let thisRoutineDateRange = startingDate ... endingDate
        for routine in routineData {
            let startDateTime = Calendar.current.date(bySettingHour: routine.startTime.0, minute: routine.startTime.1, second: 0, of: Date()) ?? Date.now
            let endDateTime = Calendar.current.date(bySettingHour: routine.endTime.0, minute: routine.endTime.1, second: 0, of: Date()) ?? Date.now
            let someRoutineDateRange = startDateTime ... endDateTime
            guard !thisRoutineDateRange.overlaps(someRoutineDateRange) else {
                dateErrorMessage = "An existing routine's time overlaps this routines time!"
                return
            }
        }
        dateErrorMessage = ""
    }
}
