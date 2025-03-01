import SwiftUI

/// A simple data model representing a task.
/// Used for UI-related operations and decoupling from Core Data.
struct TaskData {
    /// Unique identifier for the task
    let id: UUID
    
    /// Title of the task
    let title: String
    
    /// Description of the task
    let description: String
    
    /// Due date of the task
    let dueDate: Date
    
    /// Priority level of the task (e.g., "High", "Medium", "Low")
    let priority: String
    
    /// Status indicating whether the task is completed
    let isCompleted: Bool
}
