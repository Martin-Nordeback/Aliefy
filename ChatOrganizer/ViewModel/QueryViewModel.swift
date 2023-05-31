//
//  CoreDataViewModel.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-03.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: This QueryViewModel is responsible for handling user's queries - it interacts with the Core Data storage to fetch, save, and clear queries.

import CoreData
import Foundation

class QueryViewModel: ObservableObject {
    // MARK: - PROPERTIES

    // queries is used to store all queries related to the current user, which get displayed in different views.
    @Published var queries: [Query] = []
    // query is being used to handle a single query, for instance, to handle user's input in a search field.
    @Published var query = Query(question: "", answer: "")

    private var currentUser: UserEntity

    init(user: UserEntity) {
        currentUser = user
        fetchUserQueries()
    }

    // MARK: - FUNCTIONS

    // to coredata
    func saveQuery(_ query: Query) throws {
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext

        // Perform the save operation on the view context within a do-catch block
        viewContext.performAndWait {
            let historyItem = HistoryItem(context: viewContext)

            historyItem.question = query.question
            historyItem.answer = query.answer
            historyItem.dateCreated = Date()

            // Create a relationship between the historyItem and the currently logged-in user
            historyItem.user = currentUser

            do {
                try viewContext.save()
                print("Query saved successfully.")
            } catch {
                print("Failed to save query: \(error)")
            }
        }
    }

    // clear all queries associated with the current user
    func clearQueries() {
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "HistoryItem")
        fetchRequest.predicate = NSPredicate(format: "user == %@", currentUser)

        // Create a batch delete request with the fetch request
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try viewContext.execute(deleteRequest)
            try viewContext.save()

            // Fetch the current user's queries again (which should now be empty)
            fetchUserQueries()
        } catch {
            print("Failed to clear queries: \(error)")
        }
    }

    // fetch all queries associated with the current users from coredata
    func fetchUserQueries() {
        let viewContext = CoreDataManager.shared.persistentContainer.viewContext

        // Create a fetch request for HistoryItem entities
        let fetchRequest: NSFetchRequest<HistoryItem> = HistoryItem.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "user == %@", currentUser)

        do {
            let fetchedHistoryItems = try viewContext.fetch(fetchRequest)

            // Convert the fetched HistoryItem entities into Query objects and store them in the queries array
            queries = fetchedHistoryItems.map { Query(question: $0.question ?? "", answer: $0.answer ?? "") }
        } catch {
            // If any error occurs, print it to the console
            print("Failed to fetch queries: \(error)")
        }
    }
}
