//
//  OnboardingViewOne.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-24.
//

// MARK: - OVERVIEW

/// `` first onboarding screen with the concept of organizing chats using customized folders in the app.``

import SwiftUI

struct OnboardingViewOne: View {
    // MARK: - PROPERTIES

    // MARK: - BODY

    var body: some View {
        OnboardingView(
            imageName: "folderImage",
            titleText: "Organize Your Chats Effortlessly",
            subtitleText: "Welcome to Aliefy! Keep your conversations tidy and easily accessible by saving them in customized folders. Never lose track of an important chat again!",
            buttonAction: nil) //: ONBOARDINGVIEW
    }
}

// MARK: - PREVIEW

struct OnboardingViewOne_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewOne()
            .preferredColorScheme(.dark)
    }
}
