import SwiftUI

struct EventListView: View {
    @StateObject var viewModel: EventListViewModel
    
    var body: some View {
        List {
            if viewModel.events.isEmpty {
                ContentUnavailableView(
                    "No Events",
                    systemImage: "calendar.badge.plus",
                    description: Text("Tap the + button to create your first event")
                )
            } else {
                ForEach(viewModel.events) { event in
                    NavigationLink(destination: EventDetailView(viewModel: EventDetailViewModel(event: event))) {
                        EventRowView(event: event)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .onDelete(perform: viewModel.deleteEvents)
            }
        }
        .onAppear {
            viewModel.fetchEvents()
        }
        .onDisappear {
            viewModel.stopListening()
        }
    }
}

#Preview {
    let mockViewModel = EventListViewModel()
    let sampleEvent1 = Event(
        title: "Team Lunch",
        date: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        venue: "The Italian Place",
        note: "Celebrating the end of the project.",
        maxParticipants: 10,
        includeLocationLink: true
    )
    let sampleEvent2 = Event(
        title: "Marketing Meeting",
        date: Date().addingTimeInterval(86400),
        startTime: Date().addingTimeInterval(86400),
        endTime: Date().addingTimeInterval(90000),
        venue: "Conference Room B",
        note: "Discussing Q3 strategy.",
        maxParticipants: 5,
        includeLocationLink: false
    )
    mockViewModel.events = [sampleEvent1, sampleEvent2]
    
    return EventListView(viewModel: mockViewModel)
}
