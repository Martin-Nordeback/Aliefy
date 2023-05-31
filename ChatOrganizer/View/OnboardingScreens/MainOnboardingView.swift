//
//  MainOnboardingView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-05.
//

// MARK: - OVERVIEW

/// ``Navigate through our three OnboardingViews

import SwiftUI

struct MainOnboardingView: View {
    // MARK: - PROPERTIES

    @State private var selectedPage = 0
    
    @EnvironmentObject var viewModel: AuthViewModel

    // MARK: - BODY

    var body: some View {
        TabView(selection: $selectedPage) {
            OnboardingViewOne()
                .tag(0)

            OnboardingViewTwo()
                .tag(1)

            OnboardingViewThree()
                .tag(2)
        } //: TABVIEW

        .tabViewStyle(PageTabViewStyle())
        .animation(.default, value: selectedPage)
    }
}

// MARK: - PREVIEW
//
//struct MainOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainOnboardingView()
//            .preferredColorScheme(.dark)
//            // new
//            .environmentObject(AuthViewModel())
//    }
//}
