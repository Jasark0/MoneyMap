//
//  ReportsCardModel.swift
//  MoneyMap
//
//  Created by Sneha Jacob on 10/26/25.
//

import Foundation
import SwiftUI
import Supabase
import Combine

struct ReportsCardModel: Identifiable, Hashable {
    let id = UUID()
    let kind:  ReportsKind
    let progress: Double
    let subtitle: String
}
