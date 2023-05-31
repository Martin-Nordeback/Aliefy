//
//  EmptyFile.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-29.
//
// MARK: - OVERVIEW

/// `` View that displays an image, text and a button. Used is HistoryView and FolderView when the list is empty


import SwiftUI

struct EmptyFile: View {
     // MARK: - PROPERTIS
    @Binding var EmptyViewButtonClicked: Bool

    var imageName: String
    var message: String
    var buttonText: String

    var buttonAction: () -> Void?

    @Environment(\.dismiss) var dismiss

     // MARK: - BODY
    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 150)

            Text(message)

            Button {
                EmptyViewButtonClicked = true
                buttonAction()

            } label: {
                Text(buttonText)
                    .foregroundColor(.white)
                    .frame(width: 260, height: 48)
                    .foregroundColor(.white)
                    .background(Color("mainColor").gradient)
                    .cornerRadius(12)
            }//: BUTTON
            
        }//: VSTACK
        .offset(y: -60)
    }
}

 // MARK: - PREVIEW
struct EmptyFile_Previews: PreviewProvider {
    static var previews: some View {
        EmptyFile(EmptyViewButtonClicked: .constant(true), imageName: "emptyFolderImage", message: "Start by adding a new Folder", buttonText: "Add", buttonAction: {})
            .preferredColorScheme(.dark)
    }
}
