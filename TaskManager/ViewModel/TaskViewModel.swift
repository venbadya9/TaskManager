import SwiftUI
import CoreData

/// ViewModel for managing tasks in a SwiftUI Task Manager app.
class TaskViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// List of tasks fetched from Core Data
    @Published var tasks: [Task] = []
    
    /// Selected filter for task visibility ("All", "Completed", "Pending")
    @Published var filter: String = "All"
    
    /// Selected sorting option ("Due Date", "Priority", "Alphabetical")
    @Published var sortOption: String = "Due Date"
    
    /// Loading state indicator
    @Published var isLoading = true
    
    /// Boolean to control undo alert visibility
    @Published var showUndoAlert = false
    
    /// Stores the last completed task for undo functionality
    @Published var recentlyCompletedTask: Task?
    
    /// Closure to execute an undo action
    @Published var undoAction: (() -> Void)? = nil
    
    /// Stores data of the recently deleted task for restoration
    @Published var recentlyDeletedTaskData: TaskData?
    
    /// Core Data managed object context
    let viewContext: NSManagedObjectContext
    
    /// User-selected accent color stored in AppStorage
    @AppStorage("accentColor") var accentColorHex: String = Color.blue.toHex()
    
    /// User-selected theme preference (light/dark mode) stored in AppStorage
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    // MARK: - Initialization
    
    /// Initializes the ViewModel with a Core Data context and fetches tasks.
    /// - Parameter context: The Core Data managed object context.
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTasks()
    }
    
    // MARK: - Computed Properties
    
    /// Returns filtered and sorted tasks based on user selection.
    var filteredTasks: [Task] {
        let filtered = filterTasks(tasks, by: filter)
        return sortTasks(filtered)
    }
    
    // MARK: - Task Filtering & Sorting
    
    /// Filters tasks based on the selected filter.
    /// - Parameters:
    ///   - tasks: The list of tasks to filter.
    ///   - filter: The selected filter ("All", "Completed", "Pending").
    /// - Returns: A filtered list of tasks.
    func filterTasks(_ tasks: [Task], by filter: String) -> [Task] {
        switch filter {
        case "Completed": return tasks.filter { $0.isCompleted }
        case "Pending": return tasks.filter { !$0.isCompleted }
        default: return tasks
        }
    }
    
    /// Sorts tasks based on the selected sorting option.
    /// - Parameter tasks: The list of tasks to sort.
    /// - Returns: A sorted list of tasks.
    func sortTasks(_ tasks: [Task]) -> [Task] {
        switch sortOption {
        case "Priority":
            return tasks.sorted { priorityRank($0.priority) > priorityRank($1.priority) }
        case "Alphabetical":
            return tasks.sorted { $0.title < $1.title }
        default:
            return tasks.sorted { $0.order < $1.order }
        }
    }
    
    /// Converts priority level into a numerical ranking for sorting.
    /// - Parameter priority: The priority string ("High", "Medium", "Low").
    /// - Returns: A corresponding integer value (higher is more important).
    func priorityRank(_ priority: String) -> Int {
        switch priority.lowercased() {
        case "high": return 3
        case "medium": return 2
        case "low": return 1
        default: return 0
        }
    }
    
    // MARK: - Task Management
    
    /// Toggles the completion status of a task and saves the change.
    /// - Parameter task: The task to toggle.
    func toggleTaskCompletion(_ task: Task) {
        task.isCompleted.toggle()
        saveContext()
    }
    
    /// Deletes a task with undo functionality.
    /// - Parameter task: The task to be deleted.
    func deleteWithUndo(task: Task) {
        recentlyDeletedTaskData = TaskData(
            id: task.id!,
            title: task.title,
            description: task.taskDescription ?? "",
            dueDate: task.dueDate,
            priority: task.priority,
            isCompleted: task.isCompleted
        )
        
        viewContext.delete(task)
        saveContext()
        
        undoAction = { self.restoreDeletedTask() }
        showUndoAlert = true
    }
    
    /// Restores a recently deleted task.
    func restoreDeletedTask() {
        guard let data = recentlyDeletedTaskData else { return }
        
        let newTask = Task(context: viewContext)
        newTask.id = data.id
        newTask.title = data.title
        newTask.taskDescription = data.description
        newTask.dueDate = data.dueDate
        newTask.priority = data.priority
        newTask.isCompleted = data.isCompleted
        
        saveContext()
    }
    
    /// Fetches tasks from Core Data and updates the `tasks` array.
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Task.order, ascending: true)]
        
        do {
            tasks = try viewContext.fetch(request)
            isLoading = false
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
        }
    }
    
    /// Moves a task to a new position in the list and updates the order.
    /// - Parameters:
    ///   - source: The index set of the task being moved.
    ///   - destination: The new index position.
    func moveTask(from source: IndexSet, to destination: Int) {
        var taskArray = Array(tasks)
        taskArray.move(fromOffsets: source, toOffset: destination)
        
        for (index, task) in taskArray.enumerated() {
            task.order = Int16(index)
        }
        
        saveContext()
    }
    
    /// Deletes a task from the list.
    /// - Parameter offsets: The index set of the task to delete.
    func deleteTask(at offsets: IndexSet) {
        for index in offsets {
            let taskToDelete = tasks[index]
            viewContext.delete(taskToDelete)
        }
        
        saveContext()
    }
    
    // MARK: - Core Data Persistence
    
    /// Saves the Core Data context and refreshes the task list.
    private func saveContext() {
        do {
            try viewContext.save()
            fetchTasks() // Refresh the list after saving
        } catch {
            print("Error saving Core Data: \(error.localizedDescription)")
        }
    }
}
