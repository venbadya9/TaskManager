import SwiftUI

/// A view that provides filtering and sorting controls for tasks.
struct FilterAndSortControlsView: View {
    @ObservedObject var viewModel: TaskViewModel  // Reference to the task view model
    
    var body: some View {
        VStack {
            // Task filter picker (All, Completed, Pending)
            Picker("Filter", selection: $viewModel.filter) {
                Text("All").tag("All")
                Text("Completed").tag("Completed")
                Text("Pending").tag("Pending")
            }
            .pickerStyle(SegmentedPickerStyle())
            .customPickerBackground(colorHex: viewModel.accentColorHex)
            
            // Task sorting picker (Due Date, Priority, Alphabetical)
            Picker("Sort By", selection: $viewModel.sortOption) {
                Text("Due Date").tag("Due Date")
                Text("Priority").tag("Priority")
                Text("Alphabetical").tag("Alphabetical")
            }
            .pickerStyle(SegmentedPickerStyle())
            .customPickerBackground(colorHex: viewModel.accentColorHex)
        }
        .padding()
    }
}

// MARK: - View Modifier for Custom Picker Background Styling
extension View {
    /// Applies a custom background and border style to a picker.
    func customPickerBackground(colorHex: String) -> some View {
        self
            .background(RoundedRectangle(cornerRadius: 8).fill(Color.fromHex(colorHex).opacity(0.2)))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.fromHex(colorHex), lineWidth: 2)
            )
    }
}
