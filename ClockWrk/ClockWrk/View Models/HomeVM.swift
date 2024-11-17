//
//  HomeVM.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 06/01/2023.
//

import Foundation

class HomeVM: ObservableObject {
    @Published var routineName: String = ""
    @Published var routineDescription: String = ""
    @Published var startTime: String = ""
    @Published var endTime: String = ""
    @Published var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Published var currentRoutine = UserRoutine()
    @Published var userRoutines: [UserRoutine] = []
    @Published var isTimerOn = false {
        didSet { if isTimerOn == false { timer.upstream.connect().cancel() } else { timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() }}
    }
    
    func updateTasks(userRoutines: [UserRoutine]) {
        self.userRoutines = userRoutines.sorted(by: { routine1, routine2 in
            return routine1.startTime < routine2.startTime
        })
    }
    
    func checkCurrentTask(currentTime: Date) {
        currentRoutine = UserRoutine()
        guard !userRoutines.isEmpty else {
            return
        }
        for routine in userRoutines {
            if routine.startTime <= (Calendar.current.component(.hour, from: currentTime), Calendar.current.component(.minute, from: currentTime)) && routine.endTime > (Calendar.current.component(.hour, from: currentTime), Calendar.current.component(.minute, from: currentTime)) {
                currentRoutine = routine
                break
            }
        }
    }
    
    func toggleTimer() {
        isTimerOn.toggle()
    }
    
    func displayRoutine() {
        if currentRoutine.title.isEmpty {
            routineName = "Free Time"
            routineDescription = "No tasks are loaded right now. Try adding one!"
            startTime = "-"
            endTime = "-"
        } else {
            routineName = currentRoutine.title
            routineDescription = currentRoutine.description
            startTime = "\((Calendar.current.date(bySettingHour: currentRoutine.startTime.0, minute: currentRoutine.startTime.1, second: 0, of: Date()) ?? Date.now).formatted(date: Date.FormatStyle.DateStyle.omitted, time: .shortened))"
            endTime = "\((Calendar.current.date(bySettingHour: currentRoutine.endTime.0, minute: currentRoutine.endTime.1, second: 0, of: Date()) ?? Date.now).formatted(date: Date.FormatStyle.DateStyle.omitted, time: .shortened))"
        }
    }
}
