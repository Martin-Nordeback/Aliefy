//
//  InputView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-03.
//
 // MARK: - OVERVIEW
///``input field with a title, placeholder, and optional secure text entry. Used in LoginView and RegistrationView ``

import SwiftUI

struct InputView: View {
    // MARK: - PROPERTIES

    @Binding var text: String

    let title: String
    let placeholder: String
    var isSecureField = false

    // MARK: - BODY

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.semibold)
                .font(.footnote)

            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.system(size: 14))
            } else {
                TextField(placeholder, text: $text)
                    .font(.system(size: 14))
            } //: IF/ELSE

            Divider()
                .background(Color("mainColor"))
        } //: VSTACK
    }
}

// MARK: - PREVIEW

struct InputView_Previews: PreviewProvider {
    static var previews: some View {
        InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com")
            .preferredColorScheme(.dark)
    }
}
