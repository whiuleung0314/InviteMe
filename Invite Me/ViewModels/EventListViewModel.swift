import Foundation
import FirebaseFirestore
import FirebaseAuth

class EventListViewModel: ObservableObject {
    @Published var events = [Event]()
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    func fetchEvents() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        listener = db.collection("users").document(userId).collection("events")
            .order(by: "date", descending: true)
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                self.events = documents.compactMap { queryDocumentSnapshot -> Event? in
                    return try? queryDocumentSnapshot.data(as: Event.self)
                }
            }
    }
    
    func stopListening() {
        listener?.remove()
    }
    
    func deleteEvents(at offsets: IndexSet) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        
        for index in offsets {
            let event = events[index]
            if let eventId = event.id {
                db.collection("users").document(userId).collection("events").document(eventId).delete()
            }
        }
    }
}