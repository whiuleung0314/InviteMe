//
//  Event.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import Foundation
import FirebaseFirestore

struct Event: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var date: Date
    var startTime: Date
    var endTime: Date?
    var venue: String
    var note: String
    var maxParticipants: Int?
    var includeLocationLink: Bool
    var createdAt: Date
    
    init(id: String? = nil, title: String, date: Date, startTime: Date, endTime: Date? = nil, venue: String, note: String, maxParticipants: Int? = nil, includeLocationLink: Bool = false) {
        self.id = id
        self.title = title
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.venue = venue
        self.note = note
        self.maxParticipants = maxParticipants
        self.includeLocationLink = includeLocationLink
        self.createdAt = Date()
    }
} 
