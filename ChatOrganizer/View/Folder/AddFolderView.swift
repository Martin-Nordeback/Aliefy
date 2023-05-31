//
//  AddCategoryView .swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-09.
//

// MARK: - OVERVIEW

/// ``Add a new folder by entering its name, with the ability to cancel or confirm the addition.``

import SwiftUI

struct AddFolderView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: FolderViewModel

    @Binding var showingModal: Bool
    
    @State private var newFolder: String = ""

    // MARK: - BODY

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter folder name", text: $newFolder)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        HStack {
                            Spacer()

                            if !newFolder.isEmpty {
                                Button(action: {
                                    self.newFolder = ""
                                }) {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 8)
                                } //: BUTTON
                            } //: IF
                        } //: HSTACK
                    ) //: OLVERLAY

                Spacer()
            } //: VSTACK

            .navigationTitle("New Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingModal = false
                    } //: BUTTON
                } //: TOOLBARITEM

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        if !newFolder.isEmpty {
                            viewModel.addFolder(newFolder)
                            newFolder = ""
                        } //: IF
                        showingModal = false
                    } //: BUTTON
                } //: TOOLBARITEM
            } //: TOOLBAR
            .padding()
        } //: NAVIGATIONVIEW
    }
}

// MARK: - PREVIEW

struct AddFolderView_Previews: PreviewProvider {
    static var previews: some View {
        // new
        AddFolderView(showingModal: .constant(true))
            .preferredColorScheme(.dark)
    }
}
