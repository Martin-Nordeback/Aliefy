//
//  ChatView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-24.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: Displays the details of a single Query from the chat history. The view also provides an option for the user to save this Query into a selected folder.

import SwiftUI

struct QuestionAnswerHistoryView: View {
    // MARK: - PROPERTIES

    var query: Query
    @EnvironmentObject var queryViewModel: QueryViewModel
    @EnvironmentObject var folderViewModel: FolderViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isChatSaved = false
    @State private var showingFolderSelectionView = false

    // MARK: - BODY

    var body: some View {
        VStack {
            HStack {
                Spacer()
                ButtonIconView(isButtonEnabled: $isChatSaved, systemName: "plus") {
                    showingFolderSelectionView = true
                }
            }
            .padding()

            VStack(alignment: .leading) {
                Text(query.question)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)

                Text(query.answer)
                    .fontWeight(.thin)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.gray.opacity(0.1))
            )
            .padding(.horizontal)

            Spacer()
        }
        .navigationBarTitle("Chat", displayMode: .inline)
        .sheet(isPresented: $showingFolderSelectionView) { // Show the FolderSelectionView as a sheet
            FolderSelectionView(isPresented: $showingFolderSelectionView, onFolderSelected: { selectedFolder in
                print("DEBUG ChatView: Folder selected: (selectedFolder.name)")
                // Add the query to the selected folder
                folderViewModel.addMessageToFolder(folderName: selectedFolder.name, message: query)
                print("DEBUG ChatView: Attempting to save message to folder: (selectedFolder.name)") // Debug print statement

                isChatSaved = true // Update the isChatSaved state
                dismiss()
            })
            .environmentObject(folderViewModel)
        }
    }
}
