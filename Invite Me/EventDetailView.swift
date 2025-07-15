//
//  EventDetailView.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI
import SwiftData

struct EventDetailView: View {
    @Bindable var event: Event
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedDate: Date
    @State private var editedStartTime: Date
    @State private var editedEndTime: Date
    @State private var editedVenue: String
    @State private var editedNote: String
    @State private var editedMaxParticipants: String
    @State private var hasEndTime: Bool
    @State private var editedIncludeLocationLink: Bool
    @State private var showingMapSelection = false
    @State private var showingCopyPreview = false
    
    init(event: Event) {
        self.event = event
        self._editedTitle = State(initialValue: event.title)
        self._editedDate = State(initialValue: event.date)
        self._editedStartTime = State(initialValue: event.startTime)
        self._editedEndTime = State(initialValue: event.endTime ?? Date())
        self._editedVenue = State(initialValue: event.venue)
        self._editedNote = State(initialValue: event.note)
        self._editedMaxParticipants = State(initialValue: event.maxParticipants?.description ?? "")
        self._hasEndTime = State(initialValue: event.endTime != nil)
        self._editedIncludeLocationLink = State(initialValue: event.includeLocationLink)
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isEditing {
                    editView
                } else {
                    detailView
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    // Copy Button
                    Button(action: {
                        showingCopyPreview = true
                    }) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy Event")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    // Share Button
                    Button(action: shareEvent) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Event")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle(isEditing ? "Edit Event" : "Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isEditing {
                        Button("Cancel") {
                            cancelEditing()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Save") {
                            saveChanges()
                        }
                        .disabled(editedTitle.isEmpty || editedVenue.isEmpty)
                    } else {
                        Button("Edit") {
                            startEditing()
                        }
                    }
                }
            }
            .sheet(isPresented: $showingMapSelection) {
                MapSelectionView(selectedVenue: $editedVenue)
            }
            .sheet(isPresented: $showingCopyPreview) {
                CopyPreviewView(
                    formattedText: createFormattedText(),
                    onCopy: {
                        copyEvent()
                        showingCopyPreview = false
                    },
                    onCancel: {
                        showingCopyPreview = false
                    }
                )
            }
        }
    }
    
    private var detailView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                
                Divider()
                
                // Date and Time
                VStack(alignment: .leading, spacing: 8) {
                    Text("Date & Time")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text(dateFormatter.string(from: event.date))
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(timeFormatter.string(from: event.startTime))
                        
                        if let endTime = event.endTime {
                            Text("-")
                            Text(timeFormatter.string(from: endTime))
                        }
                    }
                }
                
                Divider()
                
                // Venue
                if !event.venue.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Venue")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.green)
                            Text(event.venue)
                        }
                        
                        if event.includeLocationLink {
                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(.blue)
                                Text("Location link will be included in message")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    Divider()
                }
                
                // Max Participants
                if let maxParticipants = event.maxParticipants {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Max Participants")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "person.3")
                                .foregroundColor(.orange)
                            Text("\(maxParticipants) people")
                        }
                    }
                    
                    Divider()
                }
                
                // Notes
                if !event.note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(event.note)
                    }
                }
            }
            .padding()
        }
    }
    
    private var editView: some View {
        Form {
            Section("Event Details") {
                TextField("Event Title", text: $editedTitle)
                
                DatePicker("Date", selection: $editedDate, displayedComponents: .date)
                
                DatePicker("Start Time", selection: $editedStartTime, displayedComponents: .hourAndMinute)
                
                Toggle("Add End Time", isOn: $hasEndTime)
                
                if hasEndTime {
                    DatePicker("End Time", selection: $editedEndTime, displayedComponents: .hourAndMinute)
                }
            }
            
            Section("Location & Notes") {
                HStack {
                    TextField("Venue", text: $editedVenue)
                    
                    Button(action: {
                        showingMapSelection = true
                    }) {
                        Image(systemName: "map")
                            .foregroundColor(.blue)
                    }
                }
                
                Toggle("Include location link in message", isOn: $editedIncludeLocationLink)
                    .disabled(editedVenue.isEmpty)
                
                TextField("Notes", text: $editedNote, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section("Participants") {
                TextField("Max Number of Participants (Optional)", text: $editedMaxParticipants)
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private func startEditing() {
        isEditing = true
    }
    
    private func cancelEditing() {
        // Reset to original values
        editedTitle = event.title
        editedDate = event.date
        editedStartTime = event.startTime
        editedEndTime = event.endTime ?? Date()
        editedVenue = event.venue
        editedNote = event.note
        editedMaxParticipants = event.maxParticipants?.description ?? ""
        hasEndTime = event.endTime != nil
        editedIncludeLocationLink = event.includeLocationLink
        
        isEditing = false
    }
    
    private func saveChanges() {
        event.title = editedTitle
        event.date = editedDate
        event.startTime = editedStartTime
        event.endTime = hasEndTime ? editedEndTime : nil
        event.venue = editedVenue
        event.note = editedNote
        event.maxParticipants = Int(editedMaxParticipants)
        event.includeLocationLink = editedIncludeLocationLink
        
        do {
            try modelContext.save()
            isEditing = false
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    private func copyEvent() {
        let formattedText = createFormattedText()
        UIPasteboard.general.string = formattedText
        
        // Show a brief feedback (you could add a toast notification here)
        print("Event copied to clipboard")
    }
    
    private func shareEvent() {
        let shareText = createFormattedText()
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func createFormattedText() -> String {
        var text = "🎉 \(event.title)\n\n"
        text += "📅 Date: \(dateFormatter.string(from: event.date))\n"
        text += "🕐 Time: \(timeFormatter.string(from: event.startTime))"
        
        if let endTime = event.endTime {
            text += " - \(timeFormatter.string(from: endTime))"
        }
        text += "\n"
        
        if !event.venue.isEmpty {
            text += "📍 Venue: \(event.venue)"
            if event.includeLocationLink {
                let encodedVenue = event.venue.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? event.venue
                text += "\n🗺️ Location: https://maps.apple.com/?q=\(encodedVenue)"
            }
            text += "\n"
        }
        
        if !event.note.isEmpty {
            text += "📝 Notes: \(event.note)\n"
        }
        
        if let maxParticipants = event.maxParticipants {
            text += "\n👥 Participants:\n"
            for i in 1...maxParticipants {
                text += "\(i). \n"
            }
        }
        
        text += "\n━━━━━━━━━━━━━━━\n"
        text += "📱 Created with Invite Me"
        return text
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Event.self, configurations: config)
    
    let sampleEvent = Event(
        title: "Sample Event",
        date: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        venue: "Sample Venue",
        note: "This is a sample event for preview",
        includeLocationLink: true
    )
    
    return EventDetailView(event: sampleEvent)
        .modelContainer(container)
} 
