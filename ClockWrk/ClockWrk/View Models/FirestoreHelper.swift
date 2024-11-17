//
//  FirestoreManager.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 27/12/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI

class FirestoreHelper: ObservableObject {
    private let firestore = Firestore.firestore()
    @Published var userData = UserModel()
    @Published var routineData: [UserRoutine] = []
    
    init(uid: String) {
        fetchUserEntry(uid: uid)
        fetchRoutineEntries(uid: uid)
    }
    
    func createUserEntry(uid: String, fullname: String, email: String, pUrl: String) {
        let userData = ["uid": uid, "fullname": fullname, "email": email, "profileUrl": pUrl]
        firestore.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Cannot create user entry with uid: \(uid) Error: \(error)")
                return
            }
            
            print("Success")
        }
    }
    
    func fetchUserEntry(uid: String) {
        firestore.collection("users").document(uid).getDocument { documentSnapshot, error in
            if let error = error {
                print("Cannot fetch user with uid: \(uid) Error: \(error)")
                return
            }
            guard let data = documentSnapshot?.data() else {
                print("Empty")
                return
            }
            self.userData.uid = data["uid"] as? String ?? ""
            self.userData.email = data["email"] as? String ?? ""
            self.userData.fullname = data["fullname"] as? String ?? ""
            self.userData.profileUrl = data["profileUrl"] as? String ?? ""
        }
    }
    
    func fetchRoutineEntries(uid: String) {
        firestore.collection("users").document(uid).collection("routines").getDocuments { snapshot, error in
            if let error = error {
                print("Cannot fetch user routine with uid: \(uid) Error: \(error)")
                return
            }
            guard let snapshot = snapshot else {
                print("Cannot find user snapshot with uid: \(uid)")
                return
            }
            self.routineData = snapshot.documents.map { s in
                let startHour = s["startHour"] as? String ?? ""
                let startMinute = s["startMinute"] as? String ?? ""
                let endHour = s["endHour"] as? String ?? ""
                let endMinute = s["endMinute"] as? String ?? ""
                return UserRoutine(uid: uid, title: s["title"] as? String ?? "", description: s["description"] as? String ?? "", startTime: (Int(startHour) ?? 0, Int(startMinute) ?? 0), endTime: (Int(endHour) ?? 0, Int(endMinute) ?? 0), id: UUID())
            }
        }
    }
    
    func storeRoutineEntry(uid: String, routine: UserRoutine) {
        let userRoutine = ["uid": uid, "title": routine.title, "description": routine.description, "startHour": String(routine.startTime.0), "startMinute": String(routine.startTime.1), "endHour": String(routine.endTime.0), "endMinute": String(routine.endTime.1)]
        firestore.collection("users").document(uid).collection("routines").document().setData(userRoutine) { error in
            if let error = error {
                print("Cannot store routine \(routine.title) from user with uid: \(uid) Error: \(error)")
                return
            }
            print("Successfuly stored routine \(routine.title) to user \(uid) routine collection")
        }
    }
    
    func updateUserEntry(uid: String, email: String, fullname: String, selectedImage: UIImage?, profileUrl: String) -> String {
        guard !uid.isEmpty else {
            print("uid is nil! The uid cannot be nil!")
            return profileUrl
        }
        firestore.collection("users").document(uid).updateData(["email": email, "fullname": fullname]) { error in
            if let error = error {
                print("Cannot update user entry with uid: \(uid) Error: \(error)")
                return
            }
        }
        guard let image = selectedImage?.jpegData(compressionQuality: 0.5) else {
            return profileUrl
        }
        let ref = Storage.storage().reference(withPath: uid)
        var newUrl: String = profileUrl
        ref.putData(image, metadata: nil) { metadata, error in
            if let error = error {
                print("Image failed to be stored Error: \(error)")
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    print("Url failed to be retrieved Error: \(error)")
                    return
                }
                self.firestore.collection("users").document(uid).updateData(["profileUrl": url?.absoluteString ?? ""]) { error in
                    if let error = error {
                        print("Cannot update user profile picture entry with uid: \(uid) Error: \(error)")
                    }
                    print("Successfully update user profile picture entry")
                }
                print("Successfully stored image with url: \(url?.absoluteString ?? "url cannot be retrieved")")
                self.fetchUserEntry(uid: uid)
                newUrl = url?.absoluteString ?? profileUrl
            }
        }
        return newUrl
    }
    
    func appendNewRoutine(uid: String, title: String, description : String, startTime: (Int, Int), endTime: (Int, Int)) {
        let routine = UserRoutine(uid: uid, title: title, description: description, startTime: startTime, endTime: endTime, id: UUID())
        routineData.append(routine)
        print("\(routineData)")
    }
    
    func updateRoutine(oldTitle: String, uid: String, newTitle: String, newDescription : String, newStartTime: (Int, Int), newEndTime: (Int, Int)) {
        let rou = UserRoutine(uid: uid, title: newTitle, description: newDescription, startTime: newStartTime, endTime: newEndTime, id: UUID())
        var index = 0
        for _ in routineData {
            if routineData[index].title == oldTitle {
                routineData[index] = rou
            }
            index = index + 1
        }
    }
    
    func updateRoutineEntry(uid: String, oldTitle: String, newTitle: String) {
        for routine in routineData {
            if routine.title == newTitle {
                firestore.collection("users").document(uid).collection("routines").whereField("title", isEqualTo: oldTitle).getDocuments { snapshot, error in
                    if let error = error {
                        print("Cannot retrieve document with routine \(oldTitle) Error: \(error)")
                        return
                    }
                    for document in snapshot!.documents {
                        self.firestore.collection("users").document(uid).collection("routines").document(document.documentID).updateData(["uid": uid, "title": routine.title, "description": routine.description, "startHour": String(routine.startTime.0), "startMinute": String(routine.startTime.1), "endHour": String(routine.endTime.0), "endMinute": String(routine.endTime.1)]) { error in
                            if let error = error {
                                print("Cannot update routine \(oldTitle) Error: \(error)")
                                return
                            }
                            print("Successfully updated routine \(oldTitle)")
                        }
                    }
                }
            }
        }
    }
}
