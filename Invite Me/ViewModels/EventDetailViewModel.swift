import Foundation
import FirebaseFirestore
import FirebaseAuth

class EventDetailViewModel: ObservableObject {
    @Published var event: Event
    
    @Published var isEditing = false
    @Published var editedTitle: String
    @Published var editedDate: Date
    @Published var editedStartTime: Date
    @Published var editedEndTime: Date
    @Published var editedVenue: String
    @Published var editedNote: String
    @Published var editedMaxParticipants: String
    @Published var hasEndTime: Bool
    @Published var editedIncludeLocationLink: Bool
    @Published var showingMapSelection = false
    @Published var showingCopyPreview = false
    
    init(event: Event) {
        self.event = event
        self.editedTitle = event.title
        self.editedDate = event.date
        self.editedStartTime = event.startTime
        self.editedEndTime = event.endTime ?? Date()
        self.editedVenue = event.venue
        self.editedNote = event.note
        self.editedMaxParticipants = event.maxParticipants?.description ?? ""
        self.hasEndTime = event.endTime != nil
        self.editedIncludeLocationLink = event.includeLocationLink
    }
    
    var isSaveButtonDisabled: Bool {
        editedTitle.isEmpty || editedVenue.isEmpty
    }
    
    func startEditing() {
        isEditing = true
    }
    
    func cancelEditing() {
        isEditing = false
        resetEditedProperties()
    }
    
    func saveChanges() {
        guard let userId = Auth.auth().currentUser?.uid, let eventId = event.id else {
            print("User not logged in or event ID not found")
            return
        }
        
        var updatedEvent = event
        updatedEvent.title = editedTitle
        updatedEvent.date = editedDate
        updatedEvent.startTime = editedStartTime
        updatedEvent.endTime = hasEndTime ? editedEndTime : nil
        updatedEvent.venue = editedVenue
        updatedEvent.note = editedNote
        updatedEvent.maxParticipants = Int(editedMaxParticipants)
        updatedEvent.includeLocationLink = editedIncludeLocationLink
        
        let db = Firestore.firestore()
        do {
            try db.collection("users").document(userId).collection("events").document(eventId).setData(from: updatedEvent)
            self.event = updatedEvent
            isEditing = false
        } catch {
            print("Error saving changes: \(error)")
        }
    }
    
    
    
    private func resetEditedProperties() {
        editedTitle = event.title
        editedDate = event.date
        editedStartTime = event.startTime
        editedEndTime = event.endTime ?? Date()
        editedVenue = event.venue
        editedNote = event.note
        editedMaxParticipants = event.maxParticipants?.description ?? ""
        hasEndTime = event.endTime != nil
        editedIncludeLocationLink = event.includeLocationLink
    }
    
    func createFormattedText() -> String {
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
}