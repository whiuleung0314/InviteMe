//
//  CopyPreviewView.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI

struct CopyPreviewView: View {
    let formattedText: String
    let onCopy: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Preview Header
                VStack(spacing: 8) {
                    Image(systemName: "doc.text")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                    
                    Text("Preview Copied Text")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This is what will be copied to your clipboard")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Text Preview
                ScrollView {
                    Text(formattedText)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: onCopy) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy to Clipboard")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel")
                            .foregroundColor(.secondary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .navigationTitle("Copy Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onCancel()
                    }
                }
            }
        }
    }
}

#Preview {
    let sampleText = """
    🎉 Team Meeting

    📅 Date: Monday, January 15, 2025
    🕐 Time: 2:00 PM - 4:00 PM
    📍 Venue: Conference Room A
    📝 Notes: Important meeting with stakeholders

    👥 Participants (5 max):
    1. 
    2. 
    3. 
    4. 
    5. 

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📱 Created with Invite Me
    """
    
    return CopyPreviewView(
        formattedText: sampleText,
        onCopy: { print("Copy action") },
        onCancel: { print("Cancel action") }
    )
} 
