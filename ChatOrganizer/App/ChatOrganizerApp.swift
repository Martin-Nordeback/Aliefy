//
//  ChatOrganizerApp.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-02.
//
// MARK: - OVERVIEW

/// ``  Main entry point of the app. Configuring the Firebase integration and provided the necessary environment objects.


import Firebase
import SwiftUI

@main
struct ChatOrganizerApp: App {
    @StateObject var viewModel = AuthViewModel()
    @StateObject var splashScreenViewModel = SplashScreenViewModel()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(splashScreenViewModel)
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)

                .environmentObject(viewModel)
                .preferredColorScheme(.dark)
        }
    }
}
