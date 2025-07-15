//
//  EventListView.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI
import SwiftData

struct EventListView: View {
    @Query(sort: \Event.date) private var events: [Event]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            if events.isEmpty {
                ContentUnavailableView(
                    "No Events",
                    systemImage: "calendar.badge.plus",
                    description: Text("Tap the + button to create your first event")
                )
            } else {
                ForEach(events) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        EventRowView(event: event)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete(perform: deleteEvents)
            }
        }
    }
    
    private func deleteEvents(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(events[index])
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting event: \(error)")
        }
    }
}

struct EventRowView: View {
    let event: Event
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(dateFormatter.string(from: event.date))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Image(systemName: "clock")
                    .foregroundColor(.blue)
                Text(timeFormatter.string(from: event.startTime))
                
                if let endTime = event.endTime {
                    Text("-")
                    Text(timeFormatter.string(from: endTime))
                }
                
                Spacer()
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            if !event.venue.isEmpty {
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.green)
                    Text(event.venue)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            
            if !event.note.isEmpty {
                Text(event.note)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if let maxParticipants = event.maxParticipants {
                HStack {
                    Image(systemName: "person.3")
                        .foregroundColor(.orange)
                    Text("\(maxParticipants) participants max")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    EventListView()
        .modelContainer(for: Event.self, inMemory: true)
} 