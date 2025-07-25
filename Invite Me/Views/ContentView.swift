//
//  ContentView.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showingAddEvent = false
    @StateObject private var eventListViewModel = EventListViewModel()
    
    var body: some View {
        NavigationView {
            EventListView(viewModel: eventListViewModel)
                .navigationTitle("Invite Me")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showingAddEvent = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
        .sheet(isPresented: $showingAddEvent) {
            AddEventView()
        }
    }
}

#Preview {
    ContentView()
}
