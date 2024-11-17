//
//  UserModel.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 27/12/2022.
//

import Foundation

struct UserModel {
    var uid: String = ""
    var email: String = ""
    var fullname: String = ""
    var profileUrl: String = ""
}

struct UserRoutine: Identifiable {
    var uid: String = ""
    var title: String = ""
    var description: String = ""
    var startTime: (Int, Int) = (0, 0)
    var endTime: (Int, Int) = (0, 0)
    var id = UUID()
}

struct Feedback {
    var uid: String = ""
    var rating: Int = 0
}

