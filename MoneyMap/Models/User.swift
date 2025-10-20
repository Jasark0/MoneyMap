//
//  User.swift
//  MoneyMap
//
//  Created by user279040 on 10/9/25.

import Foundation
import Supabase
import SwiftUI
import Combine

struct UserProfile: Codable {
    let id: UUID?
    let first_name: String?
}

@MainActor
class SessionManager: ObservableObject {
    @Published var userId: UUID? = nil
    @Published var firstName: String? = nil

    func setUser(id: UUID) {
        self.userId = id
    }

    func fetchProfile() async {
        guard let userId = userId else {
            print("❌ No userId found")
            return
        }

        do {
            print("🔍 Fetching profile for user ID:", userId)

            let profiles: [UserProfile] = try await supabase
                .from("profiles")
                .select("id, first_name")
                .eq("id", value: userId)
                .execute()
                .value

            if let profile = profiles.first {
                self.firstName = profile.first_name
            } else {
                print("No profile found for this user ID")
            }

        } catch {
            print("Error fetching profile:", error)
        }
    }

    static var preview: SessionManager {
        let manager = SessionManager()
        manager.setUser(id: UUID())
        manager.firstName = "PreviewUser"
        return manager
    }
}
