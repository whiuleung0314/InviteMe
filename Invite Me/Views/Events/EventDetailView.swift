import SwiftUI

struct EventDetailView: View {
    @ObservedObject var viewModel: EventDetailViewModel
    
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
        VStack {
            if viewModel.isEditing {
                EditEventView(title: $viewModel.editedTitle, date: $viewModel.editedDate, startTime: $viewModel.editedStartTime, endTime: $viewModel.editedEndTime, venue: $viewModel.editedVenue, note: $viewModel.editedNote, maxParticipants: $viewModel.editedMaxParticipants, hasEndTime: $viewModel.hasEndTime, includeLocationLink: $viewModel.editedIncludeLocationLink, showingMapSelection: $viewModel.showingMapSelection)
            } else {
                detailView
            }
            
            Spacer()
            
            // Action Buttons
            VStack(spacing: 12) {
                // Copy Button
                Button(action: {
                    viewModel.showingCopyPreview = true
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
        .navigationTitle(viewModel.isEditing ? "Edit Event" : "Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if viewModel.isEditing {
                    Button("Cancel") {
                        viewModel.cancelEditing()
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isEditing {
                    Button("Save") {
                        viewModel.saveChanges()
                    }
                    .disabled(viewModel.isSaveButtonDisabled)
                } else {
                    Button("Edit") {
                        viewModel.startEditing()
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showingMapSelection) {
            MapSelectionView(selectedVenue: $viewModel.editedVenue)
        }
        .sheet(isPresented: $viewModel.showingCopyPreview) {
            CopyPreviewView(
                formattedText: viewModel.createFormattedText(),
                onCopy: {
                    copyEvent()
                    viewModel.showingCopyPreview = false
                },
                onCancel: {
                    viewModel.showingCopyPreview = false
                }
            )
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
                    Text(viewModel.event.title)
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
                        Text(dateFormatter.string(from: viewModel.event.date))
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Text(timeFormatter.string(from: viewModel.event.startTime))
                        
                        if let endTime = viewModel.event.endTime {
                            Text("-")
                            Text(timeFormatter.string(from: endTime))
                        }
                    }
                }
                
                Divider()
                
                // Venue
                if !viewModel.event.venue.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Venue")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "location")
                                .foregroundColor(.green)
                            Text(viewModel.event.venue)
                        }
                        
                        if viewModel.event.includeLocationLink {
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
                if let maxParticipants = viewModel.event.maxParticipants {
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
                if !viewModel.event.note.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Text(viewModel.event.note)
                    }
                }
            }
            .padding()
        }
    }

    private func copyEvent() {
        let formattedText = viewModel.createFormattedText()
        UIPasteboard.general.string = formattedText
        print("Event copied to clipboard")
    }

    private func shareEvent() {
        let shareText = viewModel.createFormattedText()
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

#Preview {
    let sampleEvent = Event(
        title: "Sample Event",
        date: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        venue: "Sample Venue",
        note: "This is a sample event for preview",
        includeLocationLink: true
    )
    
    return EventDetailView(viewModel: EventDetailViewModel(event: sampleEvent))
}