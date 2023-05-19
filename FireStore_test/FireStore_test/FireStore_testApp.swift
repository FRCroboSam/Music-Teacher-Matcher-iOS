//
//  FireStore_testApp.swift
//  FireStore_test
//
//  Created by Samuel Wang on 4/2/23.
//

import SwiftUI

@main
struct FireStore_testApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
