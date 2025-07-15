//
//  AddEventView.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI
import SwiftData

struct AddEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var venue = ""
    @State private var note = ""
    @State private var hasEndTime = false
    @State private var maxParticipants: String = ""
    @State private var includeLocationLink = false
    @State private var showingMapSelection = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Event Details") {
                    TextField("Event Title", text: $title)
                    
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    
                    Toggle("Add End Time", isOn: $hasEndTime)
                    
                    if hasEndTime {
                        DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    }
                }
                
                Section("Location & Notes") {
                    HStack {
                        TextField("Venue", text: $venue)
                        
                        Button(action: {
                            showingMapSelection = true
                        }) {
                            Image(systemName: "map")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Toggle("Include location link in message", isOn: $includeLocationLink)
                        .disabled(venue.isEmpty)
                    
                    TextField("Notes", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Participants") {
                    TextField("Max Number of Participants (Optional)", text: $maxParticipants)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEvent()
                    }
                    .disabled(title.isEmpty || venue.isEmpty)
                }
            }
            .sheet(isPresented: $showingMapSelection) {
                MapSelectionView(selectedVenue: $venue)
            }
        }
    }
    
    private func saveEvent() {
        let maxParticipantsInt = Int(maxParticipants)
        
        let event = Event(
            title: title,
            date: date,
            startTime: startTime,
            endTime: hasEndTime ? endTime : nil,
            venue: venue,
            note: note,
            maxParticipants: maxParticipantsInt,
            includeLocationLink: includeLocationLink
        )
        
        modelContext.insert(event)
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving event: \(error)")
        }
    }
}

#Preview {
    AddEventView()
        .modelContainer(for: Event.self, inMemory: true)
} 