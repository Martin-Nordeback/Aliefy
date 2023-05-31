//
//  FolderDetailView .swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-10.
//

// MARK: - OVERVIEW

/// ``Shows a list of messages within a folder, providing functionality for search, deletion, and moving messages.``

import SwiftUI

struct FolderDetailView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: FolderViewModel

    let folder: Folder
    
    @State private var searchText = ""

    // MARK: - BODY

    var body: some View {
        List {
            ForEach(folder.messages.filter {
                searchText.isEmpty || $0.question.localizedStandardContains(searchText)
            }, id: \.id) { message in
                NavigationLink(destination: DetailMessageView(message: message)) {
                    VStack(alignment: .leading) {
                        Text(message.question)
                            .lineLimit(1)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)

                        Text(message.answer)
                            .lineLimit(3)
                            .fontWeight(.thin)
                    } //: VSTACK
                } //: NAVIGAITONLINK
                .listRowBackground(Color.black)

                .contextMenu {
                    Section {
                        Text("Move Message to Folder")
                    } //: SECTION

                    ForEach(viewModel.folders, id: \.id) { folder in
                        if folder.id != self.folder.id {
                            Button(action: {
                                viewModel.moveMessage(message, to: folder.name)
                            }) {
                                Text(folder.name)
                                Image(systemName: "folder")
                            } //: BUTTON
                        } //: IF
                    } //: FOREACH
                } //: CONTEXTMENU
            } //: MESSAGE IN
            .onDelete(perform: deleteMessage)
        } //: LIST
        .listStyle(PlainListStyle())
        .navigationTitle(folder.name)
        .searchable(text: $searchText)
    }

    func deleteMessage(at offsets: IndexSet) {
        offsets.forEach { index in
            let message = folder.messages[index]
            viewModel.deleteMessage(message)
        } //: FOREACH
    } //: FUNC
}

// MARK: - PREVIEW

struct FolderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FolderDetailView(folder: Folder.mock)
            .environmentObject(FolderViewModel(user: User(id: "1", fullname: "Filip Hertzman", email: "filip.hertzman@gmail.com")))
            .preferredColorScheme(.dark)
    }
}
