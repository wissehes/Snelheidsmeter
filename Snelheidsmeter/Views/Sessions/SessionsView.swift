//
//  SessionsView.swift
//  Snelheidsmeter
//
//  Created by Wisse Hes on 21/09/2023.
//

import SwiftUI
import SwiftData

struct SessionsView: View {
    
    @Query var sessions: [TrackingSession]
    
    var body: some View {
        List(sessions) { session in
            NavigationLink {
                SessionDetailView(session: session)
            } label: {
                VStack(alignment: .leading) {
                    Text("\(session.startDate, style: .date) - \(session.startDate, style: .time)")
                    Text("\(session.startDate, style: .time) -> \(session.endDate ?? Date(), style: .time)")
                }
            }

            
        }.navigationTitle("Sessies")
            .overlay {
                if sessions.isEmpty {
                    ContentUnavailableView("Nog geen sessies", systemImage: "magnifyingglass")
                }
            }
    }
}

#Preview {
    SessionsView()
}
