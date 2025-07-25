import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddEventViewModel: ObservableObject {
    @Published var title = ""
    @Published var date = Date()
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var venue = ""
    @Published var note = ""
    @Published var hasEndTime = false
    @Published var maxParticipants: String = ""
    @Published var includeLocationLink = false
    @Published var showingMapSelection = false

    var isSaveButtonDisabled: Bool {
        title.isEmpty || venue.isEmpty
    }

    func saveEvent(completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in")
            completion(false)
            return
        }

        let maxParticipantsInt = Int(maxParticipants)

        let newEvent = Event(
            title: title,
            date: date,
            startTime: startTime,
            endTime: hasEndTime ? endTime : nil,
            venue: venue,
            note: note,
            maxParticipants: maxParticipantsInt,
            includeLocationLink: includeLocationLink
        )

        let db = Firestore.firestore()
        do {
            try db.collection("users").document(userId).collection("events").addDocument(from: newEvent)
            completion(true)
        } catch {
            print("Error saving event: \(error)")
            completion(false)
        }
    }
}
