//
//  AuthViewModel.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-04.
//

// MARK: - OVERVIEW

/// ``This class represents the business logic for authenticating a user with Firebase and set the user to Core Data.``

import CoreData
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import Foundation
import GoogleSignIn
import GoogleSignInSwift

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject {
    // This propertys holds the current user's authentication session.
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?

    @Published var folderViewModel: FolderViewModel?
    @Published var queryViewModel: QueryViewModel?

    // Check if the user is new to the system. Used to handle onboarding scenarios.
    @Published var isNewUser: Bool = false

    // An error message that can be displayed in the UI if an error occurs during authentication.
    @Published var errorMessage: String = ""
    @Published var showAlert: Bool = false

    // ManagedObjectContext is part of CoreData that is used to manage a set of CoreData objects.
    private var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }

    // Constructor to initialize the ViewModel and fetch user data.
    init() {
        userSession = Auth.auth().currentUser
        print("DEBUG AuthViewModel S init: User session: \(String(describing: userSession))")

        Task {
            await fetchUser()
            print("DEBUG: AuthViewModel S task fetchUser: Current user after fetching: \(String(describing: currentUser))")
        }
    }

    // This function is responsible for signing in a user using their email and password.
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            userSession = result.user
            await fetchUser()
            print("DEBUG AuthViewModel S signIn :Signed in as: \(String(describing: currentUser))")

        } catch {
            errorMessage = "Failed to sign in with error \(error.localizedDescription)"
            showAlert = true
            print("DEBUG AuthViewModel F: Failed to log in with error: \(error.localizedDescription)")
        }
    }

    // This function is used to create a new user with the provided email, password, and fullname.
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            userSession = result.user

            isNewUser = true

            // Encode the user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)

            // Set the user to to Entity
            let userEntity = UserEntity(context: viewContext)
            userEntity.id = result.user.uid

            do {
                try viewContext.save()
            } catch {
                print("DEBUG AuthViewModel F: Failed to save new user to CoreData: \(error)")
            }

            await fetchUser()
            print("DEBUG AuthViewModel S createUser: Created user: \(String(describing: currentUser))")

        } catch {
            errorMessage = "Failed to sign up with error: \(error.localizedDescription)"
            showAlert = true
            print("DEBUG AuthViewModel F: Failed to create user with error \(error.localizedDescription)")
        }
    }

    // This function is responsible for signing out the current user.
    func signOut() {
        do {
            try Auth.auth().signOut()
            userSession = nil
            currentUser = nil
            print("DEBUG AuthViewModel S: Signed out successfully")
        } catch {
            print("DEBUG AuthVievModel F: Failed to sig out with error \(error.localizedDescription)")
        }
    }

    // This function is responsible for deleting the current user's account.
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badURL)
        }
        try await Firestore.firestore().collection("users").document(user.uid).delete()
        try await user.delete()

        userSession = nil
        currentUser = nil
    }

    // This function fetches the current user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        currentUser = try? snapshot.data(as: User.self)

        
        if let user = currentUser {
            folderViewModel = FolderViewModel(user: user)

            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", uid)

            if let userEntity = try? viewContext.fetch(fetchRequest).first {
                queryViewModel = QueryViewModel(user: userEntity)
            }
        }
        print("DEBUG AuthViewModel S fetchUser: Fetched user: \(String(describing: currentUser))")
    }

    // This function sends a password reset email to the given email address.
    func forgotPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            print("DEBUG AuthViewModel S: Password reset email sent successfully to \(email)")
        } catch {
            print("DEBUG AuthViewModel F: Failed to send password reset email with error \(error.localizedDescription)")
        }
    }

    // This function is used to sign in a user with Google.
    func signInGoogle() async throws {
        // Access the top view controller
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString

        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)

        // Sign in with Firebase Auth using the Google credentials
        do {
            let authResult = try await Auth.auth().signIn(with: credential)
            userSession = authResult.user

            // Check if the user exists in Firestore
            let uid = authResult.user.uid
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()

            // If the user doesn't exist, create a new user in Firestore
            if !snapshot.exists {
                let fullname = "\(gidSignInResult.user.profile?.givenName ?? "") \(gidSignInResult.user.profile?.familyName ?? "")"
                let email = gidSignInResult.user.profile?.email ?? ""

                let user = User(id: uid, fullname: fullname, email: email)
                let encodedUser = try Firestore.Encoder().encode(user)
                try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)

                let userEntity = UserEntity(context: viewContext)
                userEntity.id = uid

                // Save the user to CoreData
                do {
                    try viewContext.save()
                } catch {
                    print("DEBUG AuthViewModel F: Failed to save new user to CoreData: \(error)")
                }

                isNewUser = true
            }

            await fetchUser()
        } catch {
            print("DEBUG AuthViewModel F: Failed to sign in with Google with error \(error.localizedDescription)")
        }
    }
}
