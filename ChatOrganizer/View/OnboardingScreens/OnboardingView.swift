//
//  OnboardingView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-24.

// MARK: - OVERVIEW

/// ``Component that displays an onboarding screen with an image, title, subtitle, animation and an optional button

import SwiftUI

struct OnboardingView: View {
    // MARK: - PROPERTIES

    let imageName: String
    let titleText: String
    let subtitleText: String
    let buttonAction: (() -> Void)?

    @State private var isTitleAppearing = false
    @State private var isSubtitleAppearing = false
    @State private var isButtonAppearing = false

    // MARK: - BODY

    var body: some View {
        VStack(spacing: 20) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)

            Text(titleText)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("mainColor"))
                .offset(y: isTitleAppearing ? 0 : 50)
                .opacity(isTitleAppearing ? 1 : 0)
                .animation(.easeInOut(duration: 1.0), value: isTitleAppearing)

            Text(subtitleText)
                .multilineTextAlignment(.center)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .opacity(isSubtitleAppearing ? 1 : 0)
                .animation(.easeInOut(duration: 1.0), value: isSubtitleAppearing)
                .padding(.horizontal, 20)

            if let buttonAction = buttonAction {
                Button(action: buttonAction) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                        .background(Color("mainColor").gradient)
                        .cornerRadius(10)
                        .padding(.top, 8)
                        .opacity(isButtonAppearing ? 1 : 0)
                        .animation(.easeInOut(duration: 1.0), value: isButtonAppearing)
                } //: BUTTON
                .padding(.top, 50)
            } //: IF LET

            Spacer()
        } //: VSTACK
        .padding(.vertical, 40)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTitleAppearing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isSubtitleAppearing = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isButtonAppearing = true
            }
        } //: ONAPPEAR
    }
}

// MARK: - PREVIEW

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(imageName: "happyUsers", titleText: "Join Aliefy Community", subtitleText: "Become a part of our growing community with over 1 million satisfied users. Experience the difference our ChatGPT technology brings to your conversations and see why so many people trust us for their chat needs!", buttonAction: {})
            .preferredColorScheme(.dark)
    }
}
