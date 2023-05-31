//
//  background.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-07.
//
// MARK: - OVERVIEW

/// ``Background View``
///
import SwiftUI

struct backgroundView: View {
    // MARK: - PROPERTIES

    // MARK: - BODY

    var body: some View {
        ZStack {
            Image("background").ignoresSafeArea()
        } //: ZSTACK
    }
}

// MARK: - PREVIEW

struct backgroundView_Previews: PreviewProvider {
    static var previews: some View {
        backgroundView()
    }
}
