//
//  HistoryView.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-03.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: This view displays the history of chat queries and allows the user to tap a query to view it in detail(QuestionAnswerHistoryView).                                       The view also includes functionality to clear the history of queries after user confirmation.

import SwiftUI

struct HistoryView: View {
    // MARK: - PROPERTIES

    @EnvironmentObject var queryViewModel: QueryViewModel
    @State private var showResetHistoryAlert = false
    @State private var resetChat = 0
    @State private var isChatRest = false
    @State private var selectedQuery: Query?
    @Environment(\.dismiss) var dismiss

    // MARK: - BODY

    var body: some View {
        NavigationStack {
            ZStack {
                if queryViewModel.queries.isEmpty && !isChatRest {
                    EmptyFile(EmptyViewButtonClicked: $showResetHistoryAlert, imageName: "emptyHistoryImage", message: "Start a New Conversation", buttonText: "Chat", buttonAction: {
                        dismiss()

                    })

                } else {
                    // Latest QA will be at the top
                    List(queryViewModel.queries.reversed(), id: \.self) { query in
                        // Each row is a question text which can be tapped to show the query detail
                        Text(query.question)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedQuery = query
                            }
                    }
                    .navigationBarItems(trailing:
                        ButtonIconView(isButtonEnabled: $showResetHistoryAlert, systemName: "arrow.clockwise", action: {
                            showResetHistoryAlert.toggle()
                        })
                    ).navigationTitle("History")
                    .alert(isPresented: $showResetHistoryAlert) {
                        Alert(title: Text("Confirm Deletion"),
                              message: Text("Are your sure you want to permanently remove these items?"),
                              primaryButton: .destructive(Text("Delete"), action: {
                                  queryViewModel.clearQueries()
                                  resetChat += 1
                                  isChatRest = true
                              }), secondaryButton: .cancel())
                    }
                    // After resetting, reset the isChatRest state variable
                    .onChange(of: resetChat) { _ in
                        isChatRest = false
                    }
                    // When a query is selected, show it in a new sheet
                    .sheet(item: $selectedQuery) { query in
                        QuestionAnswerHistoryView(query: query)
                            .environmentObject(queryViewModel)
                    }
                }
            }
        }
    }
}
