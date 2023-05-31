//
//  Query.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-03.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: Each Query is uniquely identified by an UUID. it's initializer

import Foundation

struct Query: Identifiable, Hashable {
    var id = UUID()
    let question: String
    let answer: String

    // MessageEntity initializer offers a convenient way to transform a MessageEntity into a Query
    init(entity: MessageEntity) {
        id = entity.id ?? UUID()
        question = entity.question ?? ""
        answer = entity.answer ?? ""
    }

    // Creating a Query from a question and an answer
    init(question: String, answer: String) {
        id = UUID()
        self.question = question
        self.answer = answer
    }

    static var mock: Query {
        Query(question: "Can you name a hockey player?", answer: "The best hockey player right now is Oconnor McDacid")
    }
}
