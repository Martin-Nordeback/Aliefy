//
//  Folder.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-11.
//

// MARK: - OVERVIEW

/// ``Folder with properties such as ID, name, and an array of messages (of type Query). There are two initializers: one that takes explicit parameters for ID, name, and messages, and another one that takes a FolderEntity (Core Data entity) as input.``

import Foundation

struct Folder: Identifiable, Hashable {
    let id: UUID
    var name: String
    var messages: [Query]

    init(id: UUID, name: String, messages: [Query]) {
        self.id = id
        self.name = name
        self.messages = messages
    }

    init(entity: FolderEntity) {
        id = entity.id ?? UUID()
        name = entity.name ?? ""
        messages = (entity.messages?.allObjects as? [MessageEntity])?.map { Query(entity: $0) } ?? []
    }

    static var mock: Folder {
        Folder(id: UUID(), name: "Test", messages: [Query.mock, Query(question: "Can you name a hockey brand?", answer: "One of the biggest brands is Bauer")])
    }
}
