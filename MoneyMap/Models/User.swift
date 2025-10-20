//
//  User.swift
//  MoneyMap
//
//  Created by user279040 on 10/9/25.
//

import Foundation
import SwiftUI
import Supabase
import Combine

@MainActor
class SessionManager: ObservableObject {
    @Published var userId: UUID? = nil
    @Published var isSignedIn: Bool = false
    
    func setUser(id: UUID) {
        self.userId = id
        self.isSignedIn = true
    }
    func signOut(){
        self.userId = nil
        self.isSignedIn = false
    }
    
    // Preview helper
    static var preview: SessionManager {
        let manager = SessionManager()
        manager.setUser(id: UUID())
        return manager
    }
}




