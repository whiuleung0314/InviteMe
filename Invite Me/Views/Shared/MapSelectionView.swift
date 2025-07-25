//
//  MapSelectionView.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI
import MapKit

struct MapSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedVenue: String
    
    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search for a place...", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            searchPlaces()
                        }
                    
                    Button("Search") {
                        searchPlaces()
                    }
                    .disabled(searchText.isEmpty)
                }
                .padding()
                
                // Search Results
                if !searchResults.isEmpty {
                    List(searchResults, id: \.self) { item in
                        Button(action: {
                            selectedVenue = item.name ?? "Unknown Location"
                            dismiss()
                        }) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name ?? "Unknown Location")
                                    .font(.headline)
                                
                                if let address = item.placemark.thoroughfare {
                                    Text(address)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .frame(maxHeight: 200)
                }
                
                Spacer()
                
                // Map View
                Map(position: .constant(.region(region))) {
                    ForEach(searchResults.map { MapAnnotation(item: $0) }) { annotation in
                        Marker("", coordinate: annotation.coordinate)
                            .tint(.red)
                    }
                }
            }
            .navigationTitle("Select Venue")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func searchPlaces() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            DispatchQueue.main.async {
                if let response = response {
                    searchResults = response.mapItems
                } else {
                    searchResults = []
                }
            }
        }
    }
}

struct MapAnnotation: Identifiable {
    let id = UUID()
    let item: MKMapItem
    var coordinate: CLLocationCoordinate2D {
        item.placemark.coordinate
    }
}

#Preview {
    MapSelectionView(selectedVenue: .constant(""))
} 