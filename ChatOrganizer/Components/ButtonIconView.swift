//
//  ButtonIconView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-13.
//
// MARK: - OVERVIEW

/// ``OVERVIEW: reusable & specified for icons as buttons

import SwiftUI
struct ButtonIconView: View {
    @Binding var isButtonEnabled: Bool
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .foregroundColor(.accentColor)
        }
    }
}
