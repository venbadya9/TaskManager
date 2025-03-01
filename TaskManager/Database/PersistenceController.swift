import CoreData

/// Singleton class for managing Core Data persistence
class PersistenceController {
    
    /// Shared singleton instance of `PersistenceController`
    static let shared = PersistenceController()
    
    /// Persistent container for Core Data stack
    let container: NSPersistentContainer
    
    /// Private initializer to ensure singleton usage
    private init() {
        container = NSPersistentContainer(name: "TaskManager")
        
        // Load the persistent store
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // If there is an error, log it and crash the app
                fatalError("Unresolved error: \(error), \(error.userInfo)")
            }
        }
    }
    
    /// Returns the managed object context for use in the app
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
}
