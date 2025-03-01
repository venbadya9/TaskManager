import CoreData

class MockPersistenceController {
    static let shared: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskManager")
        let description = container.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType // Prevents saving to disk
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container
    }()
}
