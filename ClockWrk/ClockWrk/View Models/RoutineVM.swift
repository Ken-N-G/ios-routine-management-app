//
//  RoutineVM.swift
//  ClockWrk
//
//  Created by KEN NARA GAZZA on 06/01/2023.
//

import Foundation

class RoutineVM: ObservableObject {
    @Published var search: String = "" {
        didSet{ if !search.isEmpty { isSearchEnabled = true } else {  isSearchEnabled = false }}
    }
    @Published var isSearchEnabled: Bool = false
}
