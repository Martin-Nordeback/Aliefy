//
//  SplashScreenViewModel.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-29.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: Only checks for the splash-screen to be finished

import Foundation

class SplashScreenViewModel: ObservableObject {
    @Published var isFinished = false
}
