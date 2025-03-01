import Foundation
import CoreData

/// Core Data Task entity extension with properties and utility functions
extension Task {
    
    /// Fetch request for retrieving `Task` objects from Core Data
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    // MARK: - Core Data Properties
    
    /// Unique identifier for the task
    @NSManaged public var id: UUID!
    
    /// Title of the task
    @NSManaged public var title: String!
    
    /// Description of the task (optional)
    @NSManaged public var taskDescription: String!
    
    /// Priority level of the task (e.g., "High", "Medium", "Low")
    @NSManaged public var priority: String!
    
    /// Due date of the task
    @NSManaged public var dueDate: Date!
    
    /// Status indicating whether the task is completed
    @NSManaged public var isCompleted: Bool
    
    /// Order position for sorting tasks
    @NSManaged public var order: Int16
}

// MARK: - Task Convenience Methods

extension Task: Identifiable {
    
    /// Creates a new `Task` object and saves it in the given Core Data context
    /// - Parameters:
    ///   - context: The `NSManagedObjectContext` to save the task
    ///   - title: The title of the task
    ///   - description: The optional description of the task
    ///   - priority: The priority level of the task
    ///   - dueDate: The due date of the task
    ///   - order: The sorting order of the task
    static func create(
        context: NSManagedObjectContext,
        title: String,
        description: String? = nil,  // Making description optional explicitly
        priority: String,
        dueDate: Date,
        order: Int16
    ) {
        let newTask = Task(context: context)
        newTask.id = UUID()
        newTask.title = title
        newTask.taskDescription = description ?? ""  // Avoids nil assignment
        newTask.priority = priority
        newTask.dueDate = dueDate
        newTask.isCompleted = false
        newTask.order = order
        
        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error.localizedDescription)")
        }
    }
}
