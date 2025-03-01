import SwiftUI

/// The main entry point for the Task Manager app.
@main
struct TaskManagerApp: App {
    /// Singleton instance of PersistenceController to manage Core Data.
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            /// The root view of the app, injecting Core Data's managed object context.
            ContentView(context: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
