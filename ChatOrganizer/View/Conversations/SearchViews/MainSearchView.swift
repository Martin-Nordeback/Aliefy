//
//  MainSearchView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-09.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: "mainview" this app, search capabilities, list of chat queries, user history, along with folder management for saving and retrieving chat queries.

import OpenAISwift
import SwiftUI

struct MainSearchView: View {
    // MARK: - PROPERTIES

    @StateObject private var viewModel = MainSearchViewModel()
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject private var queryViewModel: QueryViewModel
    @State private var showingFolderSelectionView = false
    @State private var chatText: String = ""
    @State private var isSearching: Bool = false
    @State private var isPresented: Bool = false
    @State private var isClearingChat: Bool = false
    @State private var currentQueryId: UUID? = nil

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack {
                // The QueryList view displays the list of recent chat queries.
                QueryList(currentQueryId: $currentQueryId)

                Spacer()
                // The InputArea view allows the user to input chat text.
                InputArea(chatText: $chatText, isSearching: $isSearching, currentQueryId: $currentQueryId)
                    .environmentObject(viewModel)
            }
            .padding()
            .overlay(alignment: .center) {
                if isSearching {
                    ProgressView("Searching...")
                        .tint(.accentColor)
                        .brightness(1)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white.opacity(0.1)))
                        .padding(20)
                }
            }
            // sheet for showing the users historyview
            .sheet(isPresented: $isPresented) {
                NavigationStack {
                    HistoryView().environmentObject(queryViewModel)
                }
            }
            // This toolbar contains buttons to view user history and select folders.
            .toolbar {
                ToolbarItemGroup {
                    ButtonIconView(isButtonEnabled: $isPresented, systemName: "clock") {
                        isPresented = true
                    }
                    ButtonIconView(isButtonEnabled: $showingFolderSelectionView, systemName: "folder.fill.badge.plus") {
                        showingFolderSelectionView = true

                    }.sheet(isPresented: $showingFolderSelectionView) {
                        FolderSelectionView(isPresented: $showingFolderSelectionView, onFolderSelected: { selectedFolder in
                            print("DEBUG MainSearchView S: Folder selected: (selectedFolder.name)")
                            if let lastQuery = queryViewModel.queries.last {
                                folderViewModel.addMessageToFolder(folderName: selectedFolder.name, message: lastQuery)
                                print("DEBUG MainSearchView S: Attempting to save message to folder: (selectedFolder.name)") // Debug print statement
                            }
                        })
                        .environmentObject(folderViewModel)
                    }
                }
            }
        }
    }
}
