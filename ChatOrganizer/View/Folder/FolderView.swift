//
//  FolderView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-08.
//

// MARK: - OVERVIEW

/// ``Displays a list of folders, allowing users to search, add, and delete folders, with navigation to a FolderDetailView.``

import SwiftUI

struct FolderView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: FolderViewModel

    @State private var showingAddFolderView = false
    @State private var searchText = ""

    // MARK: - BODY

    var body: some View {
        NavigationView {
            if viewModel.folders.isEmpty {
                EmptyFile(EmptyViewButtonClicked: $showingAddFolderView, imageName: "emptyFolderImage", message: "Start by adding a new Folder", buttonText: "Add", buttonAction: {})

                    .navigationTitle("Folders")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                showingAddFolderView = true
                            }) {
                                Image(systemName: "plus")
                            } //: BUTTOM
                        } //: TOOLBARITEM
                    } //: TOOLABAR
            } else {
                List {
                    ForEach(viewModel.folders.filter {
                        searchText.isEmpty || $0.name.localizedStandardContains(searchText)

                    }) { folder in // FOREACH

                        NavigationLink(destination: FolderDetailView(folder: folder)) {
                            HStack {
                                Image(systemName: "folder")
                                Text(folder.name)
                                Spacer()
                                Text("\(folder.messages.count)")
                                    .foregroundColor(.secondary)
                            } //: HSTACK
                        } //: NAVIGATIONLNIK
                    }
                    .onDelete(perform: deleteFolder)
                }
                .navigationTitle("Folders")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddFolderView = true
                        }) {
                            Image(systemName: "plus")
                        } //: BUTTON
                    } //: TOOLBARITEM
                } //: TOOLBAR
            } //: ELSE
        } //: NAVIGATIONVIEW
        .sheet(isPresented: $showingAddFolderView) {
            AddFolderView(showingModal: $showingAddFolderView)
                .environmentObject(viewModel)
        } //: SHEET
    }

    func deleteFolder(at offsets: IndexSet) {
        viewModel.deleteFolder(at: offsets)
    } // FUNC
}

// MARK: - PREVIEW

struct FolderView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
            .preferredColorScheme(.dark)
            .environmentObject(FolderViewModel(user: User(id: "1", fullname: "Filip Hertzman", email: "filip.hertzman@gmail.com")))
    }
}
