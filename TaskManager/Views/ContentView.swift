import SwiftUI
import CoreData

/// The main view of the task manager app, displaying tasks, controls, and navigation.
struct ContentView: View {
    
    /// The view model that handles task data and user interactions.
    @StateObject private var viewModel: TaskViewModel
    
    /// Initializes the view with a Core Data context.
    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: TaskViewModel(context: context))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    ShimmerPlaceholderView(viewModel: viewModel)
                        .accessibilityHidden(true)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                viewModel.fetchTasks()
                            }
                        }
                } else {
                    if !viewModel.tasks.isEmpty {
                        FilterAndSortControlsView(viewModel: viewModel)
                        
                        ProgressIndicatorView(
                            completedTasks: completedTaskCount(),
                            totalTasks: viewModel.tasks.count,
                            fillColor: Color.fromHex(viewModel.accentColorHex)
                        )
                        .padding(.vertical)
                        .accessibilityLabel("Task completion progress")
                        .accessibilityValue("\(completedTaskCount()) out of \(viewModel.tasks.count) tasks completed.")
                        
                        TaskListView(viewModel: viewModel)
                    } else {
                        EmptyStateView()
                            .accessibilityLabel("No tasks available")
                            .accessibilityHint("Create a new task using the add button.")
                            .animation(.none, value: viewModel.tasks.isEmpty)
                    }
                }
            }
            .navigationTitle("Tasks")
            .navigationBarTitleDisplayMode(.inline)
            .accessibilityLabel("Task Manager")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: TaskCreationView(viewModel: viewModel)) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color.fromHex(viewModel.accentColorHex))
                            .shadow(radius: 4)
                            .accessibilityLabel("Add a new task")
                            .accessibilityHint("Opens the task creation screen.")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color.fromHex(viewModel.accentColorHex))
                            .shadow(radius: 4)
                            .accessibilityLabel("Settings")
                            .accessibilityHint("Customize the app settings.")
                    }
                }
            }
            .alert("Undo Action", isPresented: $viewModel.showUndoAlert) {
                Button("Undo", role: .cancel) {
                    viewModel.undoAction?()
                    viewModel.undoAction = nil
                }
                Button("Dismiss", role: .destructive) {}
            }
            .accessibilityLabel("Undo Action")
            .accessibilityHint("Revert the last action.")
        }
        .preferredColorScheme(viewModel.isDarkMode ? .dark : .light)
        .onAppear {
            viewModel.isLoading = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.fetchTasks()
                viewModel.isLoading = false
            }
        }
    }
    
    /// Computes the number of completed tasks.
    private func completedTaskCount() -> Int {
        viewModel.tasks.filter { $0.isCompleted }.count
    }
}
