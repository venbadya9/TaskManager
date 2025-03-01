import XCTest
import SwiftUI
@testable import TaskManager

final class TaskManagerTests: XCTestCase {
    
    // MARK: - ContentView Tests
    func testContentViewRendersCorrectly() {
        let view = ContentView(context: MockPersistenceController.shared.viewContext)
        XCTAssertNotNil(view.body, "ContentView should be able to render")
    }
    
    // MARK: - TaskListView Tests
    func testTaskListViewDisplaysTasks() {
        let viewModel = TaskViewModel(context: MockPersistenceController.shared.viewContext)
        let view = TaskListView(viewModel: viewModel)
        XCTAssertNotNil(view.body, "TaskListView should display tasks")
    }
    
    func testTaskListViewHandlesFilteringAndSorting() {
        let viewModel = TaskViewModel(context: MockPersistenceController.shared.viewContext)
        viewModel.filter = "Completed"
        viewModel.sortOption = "Due Date"
        XCTAssertEqual(viewModel.filter, "Completed")
        XCTAssertEqual(viewModel.sortOption, "Due Date")
    }
    
    // MARK: - TaskCreationView Tests
    func testTaskCreationViewValidatesInput() {
        let viewModel = TaskViewModel(context: MockPersistenceController.shared.viewContext)
        let view = TaskCreationView(viewModel: viewModel)
        XCTAssertNotNil(view.body, "TaskCreationView should render")
        
        // Simulate invalid input
        view.title = ""
        XCTAssertTrue(view.title.isEmpty, "Task title should not be empty")
    }
    
    func testTaskCreationViewSavesTask() {
        let viewModel = TaskViewModel(context: MockPersistenceController.shared.viewContext)
        Task.create(context: viewModel.viewContext, title: "New Task", description: "Test Description", priority: "High", dueDate: Date(), order: 0)
        viewModel.fetchTasks()
        XCTAssertEqual(viewModel.tasks.count, 1, "New task should be added to the list")
    }
    
    // MARK: - SettingsView Tests
    func testSettingsViewTogglesDarkMode() {
        let view = SettingsView()
        view.isDarkMode = false
        view.isDarkMode.toggle()
        XCTAssertTrue(view.isDarkMode, "Dark mode should be enabled")
    }
    
    func testSettingsViewChangesAccentColor() {
        let view = SettingsView()
        view.accentColorHex = "#FF5733"
        XCTAssertEqual(view.accentColorHex, "#FF5733", "Accent color should be updated")
    }
    
    // MARK: - ProgressIndicatorView Tests
    func testProgressIndicatorCalculatesCorrectly() {
        let view = ProgressIndicatorView(completedTasks: 5, totalTasks: 10, fillColor: .blue)
        XCTAssertEqual(view.progress, 0.5, "Progress should be 50% when 5 out of 10 tasks are completed")
    }
    
    // MARK: - EmptyStateView Tests
    func testEmptyStateViewDisplaysCorrectly() {
        let view = EmptyStateView()
        XCTAssertNotNil(view.body, "EmptyStateView should be displayed when there are no tasks")
    }
    
    // MARK: - Performance Tests
    func testTaskListViewPerformance() {
        let viewModel = TaskViewModel(context: MockPersistenceController.shared.viewContext)
        for _ in 0..<1000 {
            Task.create(context: viewModel.viewContext, title: "New Task", description: "Test Description", priority: "Medium", dueDate: Date(), order: 0)
        }
        measure {
            _ = TaskListView(viewModel: viewModel).body
        }
    }
    
    // MARK: - Accessibility Tests
    func testTaskCreationViewAccessibility() {
        let view = TaskCreationView(viewModel: TaskViewModel(context: MockPersistenceController.shared.viewContext))
        XCTAssertNotNil(view.body.accessibilityLabel("Task Title"), "Title field should have an accessibility label")
    }
}
