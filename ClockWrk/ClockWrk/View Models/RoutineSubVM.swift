//
//  RoutineSubVM.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 05/01/2023.
//

import Foundation

class RoutineSubVM: ObservableObject {
    @Published var name: String = ""
    @Published var description: String = ""
    @Published var startTime: (Int, Int) = (0, 0)
    @Published var endTime: (Int, Int) = (0, 0)
    @Published var startDateTime: Date
    @Published var endDateTime: Date
    
    init(name: String, description: String, startTime: (Int, Int), endTime: (Int, Int)) {
        self.name = name
        self.description = description
        self.startTime = startTime
        self.endTime = endTime
        startDateTime = Calendar.current.date(bySettingHour: startTime.0, minute: startTime.1, second: 0, of: Date()) ?? Date.now
        endDateTime = Calendar.current.date(bySettingHour: endTime.0, minute: endTime.1, second: 0, of: Date()) ?? Date.now
    }
}
