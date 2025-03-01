import SwiftUI

/// Displays a list of tasks with support for deletion and reordering.
struct TaskListView: View {
    @ObservedObject var viewModel: TaskViewModel
    
    var body: some View {
        List {
            // Iterates through filtered tasks and displays each in a row
            ForEach(viewModel.filteredTasks) { task in
                TaskRowView(task: task, viewModel: viewModel)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.fromHex(viewModel.accentColorHex).opacity(0.1))
                    )
                    .listRowSeparator(.hidden) // Hides default list separators
            }
            .onDelete(perform: viewModel.deleteTask) // Enables swipe-to-delete
            .onMove(perform: viewModel.moveTask)   // Enables drag-to-reorder
        }
        .scrollIndicators(.hidden) // Hides scrollbar for a cleaner UI
        .listStyle(PlainListStyle()) // Removes extra list styling for a modern look
        .id(viewModel.filteredTasks.map(\.id)) // Ensures list refreshes correctly
        .animation(.easeInOut, value: viewModel.filteredTasks) // Smooth animations for changes
    }
}
