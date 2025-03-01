import SwiftUI

/// A single row representing a task in the task list.
struct TaskRowView: View {
    @ObservedObject var task: Task
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        // Ensure the task is still managed within Core Data before displaying it
        if task.managedObjectContext != nil {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Completion toggle button
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(task.isCompleted ? Color.fromHex(viewModel.accentColorHex) : Color.fromHex(viewModel.accentColorHex).opacity(0.5))
                        .onTapGesture { viewModel.toggleTaskCompletion(task) }
                        .accessibilityLabel(task.isCompleted ? "Mark task as incomplete" : "Mark task as complete")
                        .accessibilityHint("Double-tap to toggle task completion.")
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Task title with optional strikethrough effect
                        Text(task.title)
                            .font(.headline)
                            .foregroundColor(task.isCompleted ? Color.fromHex(viewModel.accentColorHex).opacity(0.5) : Color.fromHex(viewModel.accentColorHex))
                            .strikethrough(task.isCompleted, color: Color.fromHex(viewModel.accentColorHex))
                            .accessibilityLabel("Task title: \(task.title)")
                            .accessibilityValue(task.isCompleted ? "Completed" : "Pending")
                        
                        // Task description (optional)
                        if let description = task.taskDescription, !description.isEmpty {
                            Text(description)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .lineLimit(nil)
                                .fixedSize(horizontal: false, vertical: true)
                                .accessibilityLabel("Task description: \(description)")
                        }
                        
                        // Due date formatted properly
                        Text(task.dueDate, formatter: DateFormatter.shortStyle)
                            .font(.subheadline)
                            .foregroundColor(Color.fromHex(viewModel.accentColorHex))
                            .accessibilityLabel("Due date: \(DateFormatter.localizedString(from: task.dueDate, dateStyle: .medium, timeStyle: .none))")
                    }
                    
                    Spacer()
                    
                    // Task priority badge
                    Text(task.priority)
                        .font(.caption)
                        .padding(5)
                        .background(Capsule().fill(Color.fromHex(viewModel.accentColorHex).opacity(0.3)))
                        .accessibilityLabel("Priority: \(task.priority)")
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(UIColor.systemBackground))
                    .shadow(radius: 2)
            ) // Card-style background for better UI
            .accessibilityElement(children: .combine)
            
            // Swipe to delete action with undo
            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                Button(role: .destructive) {
                    viewModel.deleteWithUndo(task: task)
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .tint(Color.fromHex(viewModel.accentColorHex).opacity(0.5))
                .accessibilityLabel("Delete task")
                .accessibilityHint("Swipe right to delete and undo if needed.")
            }
            
            // Swipe to complete/unmark action
            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                Button {
                    viewModel.toggleTaskCompletion(task)
                } label: {
                    Label(task.isCompleted ? "Unmark" : "Complete", systemImage: task.isCompleted ? "arrow.uturn.left.circle.fill" : "checkmark.circle.fill")
                }
                .tint(Color.fromHex(viewModel.accentColorHex).opacity(0.5))
                .accessibilityLabel(task.isCompleted ? "Undo completion" : "Mark as complete")
                .accessibilityHint("Swipe left to toggle task completion.")
            }
        }
    }
}
