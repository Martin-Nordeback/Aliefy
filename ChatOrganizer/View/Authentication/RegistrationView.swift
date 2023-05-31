//
//  RegistrationView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-03.
//

// MARK: - OVERIVEW

/// ``Registration form with input fields for email, full name, password, and confirm password. Includes validation, a dismiss button and error alert.``

import SwiftUI

struct RegistrationView: View {
    // MARK: - PROPERTIES

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    // MARK: - BODY

    var body: some View {
        VStack {
            Image("loginImage")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .padding(.vertical, 32)

            VStack(spacing: 24) {
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@example.com")
                    .autocapitalization(.none)

                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Enter your name")

                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)

                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm your password",
                              isSecureField: true)

                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                    }
                } //: ZSTACK

                Button {
                    Task {
                        try await viewModel.createUser(withEmail: email,
                                                       password: password,
                                                       fullname: fullname)
                    }
                } label: {
                    HStack {
                        Text("Sign up")
                            .fontWeight(.semibold)
                    } //: HSTACK
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                } // SIGN IN BUTTON
                .background(Color("mainColor").gradient)
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .cornerRadius(10)
                .padding(.top, 24)
            } // VSTACK
            .padding(.horizontal)
            .padding(.top, 12)

            Spacer()

            Button {
                dismiss()
            } label: {
                HStack(spacing: 4) {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Text("Sign in")
                        .fontWeight(.bold)
                        .foregroundColor(Color("mainColor"))
                } //: HSTACK
                .font(.system(size: 14))
            } //: BUTTON DISMISS
        } //: VSTACK
        .background(backgroundView())
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK")))
        }
    }
}

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && password.count > 5
            && confirmPassword == password
            && !fullname.isEmpty
    }
} //: EXTENSION

// MARK: - PREVIEW

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}
