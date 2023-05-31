//
//  OnboardingViewTwo.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-24.
//

// MARK: - OVERVIEW

/// ``Second onboarding screen with usage of ChatGPT technology.

import SwiftUI

struct OnboardingViewTwo: View {
    // MARK: - PROPERTIES

    // MARK: - BODY

    var body: some View {
        OnboardingView(
            imageName: "aiImage",
            titleText: "Powered by ChatGPT Technology",
            subtitleText: "Experience seamless and engaging conversations using our advanced ChatGPT technology. Enjoy smart replies, insightful suggestions, and a more interactive chat experience like never before!",
            buttonAction: nil) //: ONBOARDINGVIEW
    }
}

// MARK: - PREVIEW

struct OnboardingViewTwo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewTwo()
            .preferredColorScheme(.dark)
    }
}
