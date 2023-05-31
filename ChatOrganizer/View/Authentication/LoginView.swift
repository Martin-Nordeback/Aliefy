//
//  LoginView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-03.
//

// MARK: - OVERVIEW

/// ``Login form with email and password fields, sign-in and sign-up buttons, and options for password recovery and signing in with Google.``

import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

struct LoginView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: AuthViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?

    // MARK: - BODY

    var body: some View {
        NavigationStack {
            VStack {
                Image("loginImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
                    .padding(.vertical, 32)

                VStack(spacing: 12) {
                    InputView(text: $email,
                              title: "Email Adress",
                              placeholder: "name@example.com")
                        .autocapitalization(.none)

                    InputView(text: $password,
                              title: "Password",
                              placeholder: "Enter your password",
                              isSecureField: true)
                } //: VSTACK
                .padding(.horizontal)
                .padding(.top, 12)

                HStack {
                    Spacer()

                    NavigationLink {
                        ForgotPasswordView()
                            .navigationBarBackButtonHidden(true)

                    } label: {
                        Text("Forgot Password?")
                            .foregroundColor(Color("mainColor"))
                            .padding(.horizontal)
                    }
                } //: HSTACK
                .padding(.trailing, 12)
                .bold()
                .font(.system(size: 14))

                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                } label: {
                    HStack {
                        Text("Sign In")
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

                Text("Or Continue with")
                    .foregroundColor(.gray)
                    .font(.callout)
                    .padding(.top, 36)
                    .padding(.bottom, 24)

                Button {
                    Task {
                        do {
                            try await viewModel.signInGoogle()
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    HStack {
                        Image("google")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)

                        Text("Google")
                            .font(.callout)
                    } //: HSTACK
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                    .foregroundColor(.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                } //: BUTTON

                Spacer()

                // sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 4) {
                        Text("Don't have an account?")
                            .foregroundColor(Color.gray)
                        Text("Sign up")
                            .fontWeight(.bold)
                            .foregroundColor(Color("mainColor"))
                    } //: HSTACK
                    .font(.system(size: 14))
                } //: NAVIGATIONLINK
            } //: VSTACK
            .background(backgroundView())
        } //: NAVIGATIONSTACK

        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Error"),
                  message: Text(viewModel.errorMessage),
                  dismissButton: .default(Text("OK")))
        } //: ALERT
    }
}

// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
            && email.contains("@")
            && password.count > 5
    }
} //: EXTENSION

// MARK: - PREVIEW

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}
