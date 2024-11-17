//
//  ProfileVM.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 03/01/2023.
//

import Foundation
import SwiftUI

class ProfileVM: ObservableObject {
    
    @Published var fullname: String = "" {
        didSet { if fullname != originalName && !fullname.isEmpty { hasUserProfileChanged = true } else { hasUserProfileChanged = false }
            saveProfileDetailsStatus = ""
        }
    }
    @Published var email: String = "" {
        didSet { if email != originalEmail && !email.isEmpty { hasUserProfileChanged = true } else { hasUserProfileChanged = false }
            saveProfileDetailsStatus = ""
        }
    }
    @Published var profileUrl: String = "" {
        didSet { if profileUrl != originalProfileUrl { hasUserProfileChanged = true } else { hasUserProfileChanged = false }
            saveProfileDetailsStatus = ""
        }
    }
    @Published var profileImage: UIImage? {
        didSet { if profileImage != nil { hasUserProfileChanged = true} else { hasUserProfileChanged = false }
            saveProfileDetailsStatus = ""
        }
    }
    
    private var originalName: String
    private var originalEmail: String
    private var originalProfileUrl: String
    @Published var hasUserProfileChanged: Bool = false
    @Published var showImagePicker: Bool = false
    
    @Published var fullnameErrorMessage: String = ""
    @Published var emailErrorMessage: String = ""
    @Published var saveProfileDetailsStatus: String = ""
    
    init(originalName: String, originalEmail: String, originalProfileUrl: String) {
        self.originalName = originalName
        self.originalEmail = originalEmail
        self.originalProfileUrl = originalProfileUrl
        fullname = originalName
        email = originalEmail
        profileUrl = originalProfileUrl
    }
    func updateProfile() {
        originalName = fullname
        originalEmail = email
        originalProfileUrl = profileUrl
    }
}
