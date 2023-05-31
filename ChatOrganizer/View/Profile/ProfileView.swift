//
//  ProfileView.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-03.
//
 // MARK: - OVERVIEW
///``User profile information, including options to sign out, delete account and navigate to the about section (AboutView).

import SwiftUI

struct ProfileView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var viewModel: AuthViewModel

    @State private var showSignOutAlert = false
    @State private var showDeleteAccountAlert = false

    // MARK: - BODY

    var body: some View {
        NavigationView {
            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)

                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: VSTACK
                        } //: HSTACK
                    } //: SECTION

                    Section("General") {
                        HStack {
                            SettingsRowView(imageName: "gear",
                                            title: "Version",
                                            tintColor: Color(.systemGray))

                            Spacer()

                            Text("1.0.0")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } //: HSTACK

                        NavigationLink {
                            AboutView()
                        } label: {
                            SettingsRowView(imageName: "info.circle", title: "About", tintColor: Color(.systemGray))
                        } //: NAVIGATIONLINK
                    } //: SECTION GENERAL

                    Section("Account") {
                        Button {
                            showSignOutAlert.toggle()
                        } label: {
                            SettingsRowView(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            tintColor: .red)
                        } //: BUTTON SIGN OUT

                        Button {
                            showDeleteAccountAlert.toggle()
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill",
                                            title: "Delete Account",
                                            tintColor: .red)
                        } //: BUTTON DELETE ACCOUNT

                        .alert(isPresented: $showSignOutAlert) {
                            Alert(title: Text("Sign Out"),
                                  message: Text("Are you sure you want to sign out?"),
                                  primaryButton: .destructive(Text("Yes"), action: {
                                      viewModel.signOut()
                                  }), secondaryButton: .cancel())
                        } //: ALERT
                    } //: SECTION ACCOUNT
                } //: LIST

                .alert(isPresented: $showDeleteAccountAlert) {
                    Alert(title: Text("Delete Account"),
                          message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                          primaryButton: .destructive(Text("Yes"), action: {
                              Task {
                                  do {
                                      try await viewModel.deleteAccount()
                                  } catch {
                                      print("DEBUG ProfileView: Failed to delete account with error \(error.localizedDescription)")
                                  } //: CATCH
                              } //: TASK
                          }), secondaryButton: .cancel())
                } //: ALERT
                .navigationTitle("Profile")
            }
        }
    }
}

// MARK: - PREVIEW

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
            .environmentObject(AuthViewModel())
    }
}
