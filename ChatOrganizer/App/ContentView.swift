//
//  ContentView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-02.
//
// MARK: - OVERVIEW

/// ``Managing the main content of the app based on the user session. new user -> MainOnboardingView/MainTabView. Not authenticated -> LoginView

import OpenAISwift
import SwiftUI

struct ContentView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: AuthViewModel
    @EnvironmentObject var splashScreenViewModel: SplashScreenViewModel

    // MARK: - BODY

    var body: some View {
        Group {
            if viewModel.userSession != nil {
                if viewModel.isNewUser {
                    MainOnboardingView()
                        .environmentObject(splashScreenViewModel)
                } else {
                    MainTabView(splashScreenViewModel: splashScreenViewModel)
                }
            } else {
                LoginView()
            }
        } //: GROUP
    }
}

// MARK: - PREVIEW

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
//            .environmentObject(CoreDataViewModel())
//            .environmentObject(AuthViewModel())
//            .preferredColorScheme(.dark)
//    }
// }
