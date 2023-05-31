//
//  InputArea.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-24.
//
// MARK: - OVERVIEW

/// ``OVERVIEW: input-field for chat, IMPORTANT! this view calls the openai api, recommended to only be called where it's needed

import SwiftUI

struct InputArea: View {
    // MARK: - PROPERTIES

    @Binding var chatText: String
    @Binding var isSearching: Bool
    @Binding var currentQueryId: UUID?
    @EnvironmentObject var viewModel: MainSearchViewModel
    @EnvironmentObject var queryViewModel: QueryViewModel

    var isFormValid: Bool {
        !chatText.isEmptyOrWhiteSpace
    }

    // MARK: - BODY

    var body: some View {
        HStack {
            TextField("Search....", text: $chatText)
                .textFieldStyle(.roundedBorder)

            Button {
                isSearching = true
                // Perform the search and handle the response from our openAi api
                viewModel.performSearch(chatText: chatText) { query in
                    DispatchQueue.main.async {
                        queryViewModel.queries.append(query)
                        do {
                            try queryViewModel.saveQuery(query)
                        } catch {
                            print(error)
                            print(error.localizedDescription)
                        }
                        // Reset the chatText field and assign the id of the new query
                        chatText = ""
                        currentQueryId = query.id
                        isSearching = false
                    }
                }
            } label: {
                Image(systemName: "paperplane.circle.fill")
                    .font(.title)
                    .rotationEffect(Angle(degrees: 45))
            }
            .buttonStyle(.borderless)
            .tint(Color.accentColor)
            .disabled(!isFormValid)
        }
    }
}

