import SwiftUI

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
    let sampleEvent = Event(
        title: "Sample Event",
        date: Date(),
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        venue: "Sample Venue",
        note: "This is a sample event for preview",
        includeLocationLink: true
    )
    
    return EventRowView(event: sampleEvent)
}
