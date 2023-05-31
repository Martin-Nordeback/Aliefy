//
//  MainTabView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-08.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: MainTabView is the main view of the application, showing a splash screen initially and then three tabbed views after the splash sequence is finished.

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var splashScreenViewModel: SplashScreenViewModel

    var body: some View {
        // Conditional view rendering based on whether the splash sequence has finished.
        if splashScreenViewModel.isFinished {
            // Conditional view rendering based on whether folderViewModel and queryViewModel are available in authViewModel.
            if let folderViewModel = authViewModel.folderViewModel,
               let queryViewModel = authViewModel.queryViewModel {
                TabView {
                    // MainSearchView & FolderView shares the same folder & query view-models instances
                    MainSearchView()
                        .environmentObject(folderViewModel)
                        .environmentObject(queryViewModel)
                        .tabItem {
                            Image(systemName: "brain.head.profile")
                            Text("Main")
                        }

                    FolderView()
                        .environmentObject(folderViewModel)
                        .tabItem {
                            Image(systemName: "folder")
                            Text("Folder")
                        }

                    ProfileView()
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                }
            }
        } else {
            // SplashScreen is shown when the splash sequence is finished. that why we need @ObservedObject property
            SplashScreen(splashScreenViewModel: splashScreenViewModel)
        }
    }
}
