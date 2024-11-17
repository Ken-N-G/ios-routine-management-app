//
//  EditPasswordVM.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 03/01/2023.
//

import Foundation

class EditPasswordVM: ObservableObject {
    @Published var newPassword: String = "" {
        didSet { if !newPassword.isEmpty && !confirmPassword.isEmpty { areFieldsComplete = true} else { areFieldsComplete = false }}
    }
    @Published var confirmPassword: String = "" {
        didSet { if !newPassword.isEmpty && !confirmPassword.isEmpty { areFieldsComplete = true} else { areFieldsComplete = false }}
    }
    @Published var areFieldsComplete: Bool = false
}
