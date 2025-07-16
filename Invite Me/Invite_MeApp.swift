//
//  Invite_MeApp.swift
//  Invite Me
//
//  Created by Hiu Leung Wong on 13-07-2025.
//

import SwiftUI
import SwiftData
import FirebaseCore

//@main
//struct Invite_MeApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(for: Event.self)
//    }
//}



import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Invite_MeApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
//      NavigationView {
//        ContentView()
//      }
//      .modelContainer(for: Event.self)
        
        NavigationStack {
          AuthenticatedView {
            Image(systemName: "number.circle.fill")
              .resizable()
              .frame(width: 100 , height: 100)
              .foregroundColor(Color(.systemPink))
              .aspectRatio(contentMode: .fit)
              .clipShape(Circle())
              .clipped()
              .padding(4)
              .overlay(Circle().stroke(Color.black, lineWidth: 2))
            Text("Welcome to Favourites!")
              .font(.title)
            Text("You need to be logged in to use this app.")
          } content: {
            ContentView()
            Spacer()
          }
        }
        
    }
  }
}
