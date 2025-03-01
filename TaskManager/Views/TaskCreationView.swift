import SwiftUI

/// View for creating a new task with customizable attributes.
struct TaskCreationView: View {
    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    @State var title = ""
    @State var description = ""
    @State var priority = "Medium"
    @State var dueDate = Date()
    
    /// Converts the stored hex color into a SwiftUI `Color` for UI consistency.
    var accentColor: Color {
        Color.fromHex(viewModel.accentColorHex)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            /// Input fields for task details
            VStack(alignment: .leading, spacing: 15) {
                // Title input field
                TextField("Title", text: $title)
                    .padding()
                    .background(accentColor.opacity(0.1))
                    .cornerRadius(12)
                    .accessibilityLabel("Task Title")
                    .accessibilityHint("Enter the task title.")
                
                // Description input field
                TextField("Description", text: $description)
                    .padding()
                    .background(accentColor.opacity(0.1))
                    .cornerRadius(12)
                    .accessibilityLabel("Task Description")
                    .accessibilityHint("Enter additional details for the task.")
                
                // Priority selection
                VStack(alignment: .leading, spacing: 10) {
                    Text("Priority")
                        .font(.headline)
                        .accessibilityLabel("Priority Selection")
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(accentColor.opacity(0.2))
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(accentColor, lineWidth: 2)
                        
                        Picker("Priority", selection: $priority) {
                            Text("Low").tag("Low")
                            Text("Medium").tag("Medium")
                            Text("High").tag("High")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.clear)
                        .accessibilityLabel("Task Priority")
                        .accessibilityValue(priority)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                }
                
                // Due date picker
                VStack(alignment: .leading, spacing: 10) {
                    Text("Due Date")
                        .font(.headline)
                        .accessibilityLabel("Task Due Date")
                    
                    DatePicker("Select Date", selection: $dueDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .scaleEffect(0.85)
                        .frame(maxHeight: 300)
                        .padding()
                        .background(accentColor.opacity(0.1))
                        .cornerRadius(12)
                        .accentColor(accentColor)
                        .accessibilityHint("Select the due date for the task.")
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5))
            .padding(.horizontal)

            // Save button
            Button(action: {
                saveTask()
            }) {
                Text("Save Task")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(accentColor.opacity(0.5))
                    .cornerRadius(12)
                    .shadow(radius: title.isEmpty ? 0 : 5)
                    .animation(.easeInOut, value: title.isEmpty)
            }
            .disabled(title.isEmpty) // Prevents saving without a title
            .padding(.horizontal)
            .accessibilityLabel("Save Task Button")
            .accessibilityHint(title.isEmpty ? "Enter a title before saving." : "Saves the task and returns to the task list.")
        }
        .padding(.top)
        .navigationTitle("New Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    .foregroundColor(accentColor)
                }
                .accessibilityLabel("Back Button")
                .accessibilityHint("Go back to the task list without saving.")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    /// Saves a new task with user-provided details.
    private func saveTask() {
        Task.create(
            context: viewModel.viewContext,
            title: title,
            description: description,
            priority: priority,
            dueDate: dueDate,
            order: Int16(viewModel.tasks.count)
        )
        viewModel.fetchTasks() // Refresh task list
        UIImpactFeedbackGenerator(style: .medium).impactOccurred() // Haptic feedback
        presentationMode.wrappedValue.dismiss() // Close the view
    }
}
