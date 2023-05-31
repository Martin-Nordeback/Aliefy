//
//  QueryList.swift
//  ChatOrganizer
//
//  Created by Martin Nordebäck on 2023-05-24.
//

// MARK: - OVERVIEW

/// ``OVERVIEW: this view displays users queries in a scrollable view. Currently selected query appearing more opaque than the others.

import SwiftUI

struct QueryList: View {
    // MARK: - PROPERTIES

    // The ID of the currently selected query
    @Binding var currentQueryId: UUID?
    @EnvironmentObject var queryViewModel: QueryViewModel

    // MARK: - BODY

    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                ForEach(queryViewModel.queries) { query in
                    VStack(alignment: .leading) {
                        Text(query.question)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)

                        Text(query.answer)
                            .fontWeight(.thin)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 40)
                    .id(query.id)
                    // Reduce the opacity of queries that are not the current query
                    .opacity(currentQueryId == query.id ? 1 : 0.25)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                // When a new query is added, scroll to it
                .onChange(of: queryViewModel.queries) { _ in
                    if let id = currentQueryId {
                        // Scroll to the currently selected query
                        withAnimation {
                            proxy.scrollTo(id)
                        }
                    }
                }
            }
        }
        .padding()
    }
}
