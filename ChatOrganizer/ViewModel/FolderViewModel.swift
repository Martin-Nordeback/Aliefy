//
//  FolderViewModel.swift
//  ChatOrganizer
//
//  Created by Filip Hertzman on 2023-05-09.
//
 // MARK: -
///``Responsible for managing folders and messages within a Core Data context. It fetches folders and the current user from Core Data, provides methods to add, delete, and edit folders and messages, and handles the movement of messages between folders.``

import CoreData
import Foundation

// new
class FolderViewModel: ObservableObject {
    
    // This array will hold the Folder objects fetched from Core Data.
    @Published var folders: [Folder] = []

    // This property will hold the UserEntity of the current user.
    private var currentUserEntity: UserEntity?

    // The viewContext is an instance of NSManagedObjectContext, which represents a single "object space" or scratchpad in Core Data.
    private var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }

    // Fetch folders and current user from Core Data when FolderViewModel is initialized
    init(user: User) {
        fetchCurrentUser(user: user)
        fetchFolders()
    }

    // This method fetches FolderEntity objects from Core Data.
    func fetchFolders() {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "user == %@", currentUserEntity ?? "")

        do {
            // Convert the fetched FolderEntity objects into Folder objects
            let fetchedFolders = try viewContext.fetch(fetchRequest)
            folders = fetchedFolders.map { Folder(entity: $0) }
        } catch {
            print("DEBUG FolderViewModel F: Failed to fetch folders: \(error)")
        }
    }

    // Fetches the UserEntity object for the current user from Core Data.
    func fetchCurrentUser(user: User) {
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", user.id as CVarArg)

        do {
            let fetchedUsers = try viewContext.fetch(fetchRequest)
            currentUserEntity = fetchedUsers.first
        } catch {
            print("DEBUG FolderViewModel F: Failed to fetch current user: \(error)")
        }
    }

    // This method creates a new FolderEntity object and saves it to Core Data.
    func addFolder(_ newFolder: String) {
        let folderEntity = FolderEntity(context: viewContext)
        folderEntity.name = newFolder
        folderEntity.id = UUID()
        folderEntity.user = currentUserEntity

        do {
            try viewContext.save()
            fetchFolders()
        } catch {
            print("DEBUG FolderViewModel F: Failed to save new folder: \(error)")
        }
    }

    // This method deletes a FolderEntity object from Core Data.
    func deleteFolder(at offsets: IndexSet) {
        // Delete each selected folder
        offsets.map { folders[$0] }.forEach { folder in
            let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", folder.id as CVarArg)

            // Fetch the FolderEntity object that corresponds to the selected Folder object and delete it
            if let result = try? viewContext.fetch(fetchRequest), let folderEntity = result.first {
                viewContext.delete(folderEntity)

                do {
                    try viewContext.save()
                    fetchFolders() // Refresh the folders after deleting one
                } catch {
                    print("DEBUG FolderViewModel F: Failed to delete folder: \(error)")
                }
            }
        }
    }

    // Deletes a MessageEntity object from Core Data.
    func deleteMessage(_ message: Query) {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", message.id as CVarArg)

        if let result = try? viewContext.fetch(fetchRequest), let messageEntity = result.first {
            viewContext.delete(messageEntity)

            do {
                try viewContext.save()
                fetchFolders()
            } catch {
                print("Failed to delete message: \(error)")
            }
        }
    }

    // This method adds a MessageEntity object to a specific FolderEntity object and saves it to Core Data.
    func addMessageToFolder(folderName: String, message: Query) {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND user == %@", folderName, currentUserEntity!)

        if let result = try? viewContext.fetch(fetchRequest), let folderEntity = result.first {
            let messageEntity = MessageEntity(context: viewContext)
            messageEntity.question = message.question
            messageEntity.answer = message.answer
            messageEntity.id = message.id
            messageEntity.folder = folderEntity

            do {
                try viewContext.save()
                fetchFolders()
            } catch {
                print("DEBUG FolderViewModel F: Failed to save new message: \(error)")
            }
        }
    }
    
    // This method edits a MessageEntity object and saves the changes to Core Data.
    func editMessage(_ message: Query, newQuestion: String) {
        let fetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", message.id as CVarArg)

        if let result = try? viewContext.fetch(fetchRequest), let messageEntity = result.first {
            messageEntity.question = newQuestion

            do {
                try viewContext.save()
                fetchFolders() // Refresh the folders to update the messages
            } catch {
                print("Failed to edit message: \(error)")
            }
        }
    }

    // This method moves a MessageEntity object from one FolderEntity object to another and saves the change to Core Data.
    func moveMessage(_ message: Query, to folderName: String) {
        let fetchRequest: NSFetchRequest<FolderEntity> = FolderEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@ AND user == %@", folderName, currentUserEntity!)

        if let result = try? viewContext.fetch(fetchRequest), let folderEntity = result.first {
            let messageFetchRequest: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
            messageFetchRequest.predicate = NSPredicate(format: "id == %@", message.id as CVarArg)

            if let messageResult = try? viewContext.fetch(messageFetchRequest), let messageEntity = messageResult.first {
                messageEntity.folder = folderEntity

                do {
                    try viewContext.save()
                    fetchFolders()
                } catch {
                    print("Failed to move message: \(error)")
                }
            }
        }
    }
}
