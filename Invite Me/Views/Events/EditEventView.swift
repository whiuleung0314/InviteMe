import SwiftUI

struct EditEventView: View {
    @Binding var title: String
    @Binding var date: Date
    @Binding var startTime: Date
    @Binding var endTime: Date
    @Binding var venue: String
    @Binding var note: String
    @Binding var maxParticipants: String
    @Binding var hasEndTime: Bool
    @Binding var includeLocationLink: Bool
    @Binding var showingMapSelection: Bool
    
    var body: some View {
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
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var title = "Sample Event"
        @State private var date = Date()
        @State private var startTime = Date()
        @State private var endTime = Date()
        @State private var venue = "Sample Venue"
        @State private var note = "This is a sample event for preview"
        @State private var maxParticipants = "10"
        @State private var hasEndTime = true
        @State private var includeLocationLink = true
        @State private var showingMapSelection = false
        
        var body: some View {
            EditEventView(
                title: $title, 
                date: $date, 
                startTime: $startTime, 
                endTime: $endTime, 
                venue: $venue, 
                note: $note, 
                maxParticipants: $maxParticipants, 
                hasEndTime: $hasEndTime, 
                includeLocationLink: $includeLocationLink, 
                showingMapSelection: $showingMapSelection
            )
        }
    }
    return PreviewWrapper()
}
