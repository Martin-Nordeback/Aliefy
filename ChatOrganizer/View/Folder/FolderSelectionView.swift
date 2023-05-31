//
//  FolderSelectionView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-11.
//

// MARK: - OVERVIEW

/// ``Display a list of folders to choose from, allowing users to save message to a specific folder. It is used in MainSearchView.

import SwiftUI

struct FolderSelectionView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var folderViewModel: FolderViewModel
    
    @Binding var isPresented: Bool
    
    let onFolderSelected: (Folder) -> Void

    // MARK: - BODY

    var body: some View {
        NavigationView {
            List(folderViewModel.folders) { folder in

                Button(action: {
                    print("DEBUG FolderSelectionView S: Folder selected: \(folder.name)")
                    onFolderSelected(folder)
                    isPresented = false
                }) { //: BUTTON
                    HStack {
                        Image(systemName: "folder")
                        Text(folder.name)

                        Spacer()
                        Text("\(folder.messages.count)")
                            .foregroundColor(.secondary)
                    }
                    .foregroundColor(.white)
                }
            } //: LIST
            .navigationTitle("Save to folder")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    } //: BUTTON
                } //: TOOLBARITEM
            } //: TOOLBAR
        } //: NAVIGATIONVIEW
    }
}

// MARK: - PREVIEW

// struct FolderSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderSelectionView(isPresented: .constant(true), onFolderSelected: { _ in })
//            .environmentObject(FolderViewModel())
//            .preferredColorScheme(.dark)
//    }
// }
