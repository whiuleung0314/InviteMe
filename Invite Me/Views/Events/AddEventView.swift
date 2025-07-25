import SwiftUI

struct AddEventView: View {
    @StateObject private var viewModel = AddEventViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Event Details") {
                    TextField("Event Title", text: $viewModel.title)

                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)

                    DatePicker("Start Time", selection: $viewModel.startTime, displayedComponents: .hourAndMinute)

                    Toggle("Add End Time", isOn: $viewModel.hasEndTime)

                    if viewModel.hasEndTime {
                        DatePicker("End Time", selection: $viewModel.endTime, displayedComponents: .hourAndMinute)
                    }
                }

                Section("Location & Notes") {
                    HStack {
                        TextField("Venue", text: $viewModel.venue)

                        Button(action: {
                            viewModel.showingMapSelection = true
                        }) {
                            Image(systemName: "map")
                                .foregroundColor(.blue)
                        }
                    }

                    Toggle("Include location link in message", isOn: $viewModel.includeLocationLink)
                        .disabled(viewModel.venue.isEmpty)

                    TextField("Notes", text: $viewModel.note, axis: .vertical)
                        .lineLimit(3...6)
                }

                Section("Participants") {
                    TextField("Max Number of Participants (Optional)", text: $viewModel.maxParticipants)
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
                        viewModel.saveEvent { success in
                            if success {
                                dismiss()
                            }
                        }
                    }
                    .disabled(viewModel.isSaveButtonDisabled)
                }
            }
            .sheet(isPresented: $viewModel.showingMapSelection) {
                MapSelectionView(selectedVenue: $viewModel.venue)
            }
        }
    }
}

#Preview {
    AddEventView()
}
