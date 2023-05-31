//
//  AboutView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-23.
//
 // MARK: - OVERVIEW
///``Display information about the app in a List, same information as in the OnboardingViews``

import SwiftUI

struct AboutView: View {
    // MARK: - PROPERTIES

    // MARK: - BODY

    var body: some View {
        List {
            Section {
                SectionView(
                    title: "Organize Your Chats Effortlessly",
                    description: "Welcome to Aliefy! Keep your conversations tidy and easily accessible by saving them in customized folders. Never lose track of an important chat again!")
            } //: SECTION

            Section {
                SectionView(
                    title: "Powered by ChatGPT Technology",
                    description: "Experience seamless and engaging conversations using our advanced ChatGPT technology. Enjoy smart replies, insightful suggestions, and a more interactive chat experience like never before!")
            } //: SECTION

            Section {
                SectionView(
                    title: "Join Aliefy Community",
                    description: "Become a part of our growing community with over 1 million satisfied users. Experience the difference our ChatGPT technology brings to your conversations and see why so many people trust us for their chat needs!")
            } //: SECTION
        } //: LIST
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - PREVIEW

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
            .preferredColorScheme(.dark)
    }
}
