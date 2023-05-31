//
//  DetailMessageView .swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-11.
//

// MARK: - OVERVIEW

/// ``Displays the details of a specific message, allowing users to share the message, edit its title.``

import SwiftUI

struct DetailMessageView: View {
    // MARK: - PROPERTIES

    let message: Query

    @State private var isShareSheetShowing = false
    @State private var isEditingAlertShowing = false
    @State private var editedQuestion = ""

    @EnvironmentObject var viewModel: FolderViewModel

    // MARK: - BODY

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(message.question)
                    .fontWeight(.bold)
                    .padding(.bottom, 4)

                Text(message.answer)
                    .fontWeight(.thin)

                Spacer()
            } //: VSTACK
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, -30)
        } //: SCROLLVIEW
        .scrollIndicators(.hidden)

        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isShareSheetShowing = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                } //: BUTTON
            } //: TOOLBARITEM

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    isEditingAlertShowing = true
                } label: {
                    Image(systemName: "pencil")
                } //: BUTTON
            } //: TOOLBARITEM
        } //: TOOLBAR

        .alert("Change the title", isPresented: $isEditingAlertShowing) {
            TextField("Enter the new title", text: $editedQuestion)
                .foregroundColor(.white)
            Button("Save", action: {
                viewModel.editMessage(message, newQuestion: editedQuestion)
                isEditingAlertShowing = false
            }) //: BUTTON

            Button("Cancel", role: .cancel) { isEditingAlertShowing = false }
        } message: {
            Text("Please enter a new title for the message.")
        } //: ALERT/MESSAGE

        .sheet(isPresented: $isShareSheetShowing) {
            ShareSheet(activityItems: [message.question, message.answer])
                .presentationDetents([.medium, .large])
        } //: ALERT
    }
}

// MARK: - PREVIEW

struct DetailMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailMessageView(message: Query(question: "Who is the best hockey player", answer: "Oconnor McDavid"))
                .preferredColorScheme(.dark)
        }
    }
}
