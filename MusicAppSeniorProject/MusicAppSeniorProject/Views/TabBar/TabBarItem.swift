//
//  TabBarItem.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Nick Sarno on 9/6/21.
//

import Foundation
import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable {
    case available, requested, matched, editProfile
    var iconName: String {
        switch self {
        case .available: return "person.crop.circle.fill.badge.plus"
        case .requested: return "person.crop.circle.badge.questionmark"
        case .matched: return "person.crop.circle.badge.checkmark"
        case .editProfile: return "person.crop.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .available: return "Available"
        case .requested: return "Requested"
        case .matched: return "Matched"
        case .editProfile: return "Edit Profile"
        }
    }
    
    var color: Color {
        switch self {
        case .available: return Color.teal
        case .requested: return Color.blue
        case .matched: return Color.green
        case .editProfile: return Color.orange
        }
    }
}
