//
//  ImageSwipeNeoSoftSwitUIApp.swift
//  ImageSwipeNeoSoftSwitUI
//
//  Created by RudreshUppin on 25/04/25.
//

import SwiftUI

@main
struct ImageSwipeNeoSoftSwitUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainImageListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
