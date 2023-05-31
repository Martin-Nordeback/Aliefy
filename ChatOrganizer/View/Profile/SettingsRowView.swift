//
//  SettingsRowView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-03.
//
 // MARK: - OVERVIEW
///``displays a row with an image and a title. It is used to represent settings options in the ProfileView``

import SwiftUI

struct SettingsRowView: View {
    // MARK: - PROPERTIES

    let imageName: String
    let title: String
    let tintColor: Color

    // MARK: - BODY

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)

            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
        } //: HSTACK
    }
}

// MARK: - PREVIEW

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
            .preferredColorScheme(.dark)
    }
}
