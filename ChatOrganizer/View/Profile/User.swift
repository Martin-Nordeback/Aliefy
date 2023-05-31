//
//  User.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-03.
//

// MARK: - OVERVIEW

/// ``User with properties such as ID, full name, and email. It also includes a computed property "initials" that generates initials from the user's full name``

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Kobe Bryant", email: "test@gmail.com")
}
