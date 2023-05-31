//
//  MainSearchViewModel.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-09.
//

// MARK: - OVERVIEW

/// ``OVERVIEW:Responsible for communicating with the OpenAI API.

import Combine
import Foundation
import OpenAISwift
import SwiftUI

class MainSearchViewModel: ObservableObject {
    // MARK: - FUNCTIONS

    /// - Parameter completion: A closure that takes a `Query` object and returns void. It's called after the OpenAI API request finishes.
    /// - completion closure is marked as @escaping because it's called after an asynchronous operation - in this case, the network request to OpenAI API.
    ///   This means that the completion closure will be called at some point in the future, after performSearch has returned.
    func performSearch(chatText: String, completion: @escaping (Query) -> Void) {
        // Sends a completion request to the OpenAI API.
        OPENAI.sendCompletion(with: chatText, maxTokens: 500) { result in
            // Handles the result of the API call.
            switch result {
            case let .success(success):
                print(success)
                let answer = success.choices?.first?.text.trimmingCharacters(in:
                    .whitespacesAndNewlines) ?? ""
                let query = Query(question: chatText, answer: answer)

                completion(query)

            case let .failure(failure):
                print(failure)
                print(failure.localizedDescription)
            }
        }
    }
}
