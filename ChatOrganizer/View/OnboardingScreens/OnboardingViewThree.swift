//
//  OnboardingViewThree.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-05.
//
// MARK: - OVERVIEW
///``Third and last onboarding screen with a text of the Aliefy community. Button that takes us to MainTabView. 

import SwiftUI

struct OnboardingViewThree: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var splashScreenViewModel: SplashScreenViewModel

    @State private var isNavigationActive = false

    // MARK: - BODY
    var body: some View {
        NavigationStack {
            OnboardingView(
                imageName: "happyUsers",
                titleText: "Join Aliefy Community",
                subtitleText: "Become a part of our growing community with over 1 million satisfied users. Experience the difference our ChatGPT technology brings to your conversations and see why so many people trust us for their chat needs!"){
                    viewModel.isNewUser = false
                    isNavigationActive = true
                    
                }//: ONBOARDINGVIEW
        }//: NAVIGATIONSTACK
        .navigationDestination(isPresented: $isNavigationActive) {
            MainTabView(splashScreenViewModel: splashScreenViewModel)
        }//: NAVIGATIONDESTINATION
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - PREVIEW

struct OnboardingViewThree_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingViewThree()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}
