import SwiftUI

/// A circular progress indicator that visually represents the percentage of completed tasks.
struct ProgressIndicatorView: View {
    let completedTasks: Int  // Number of completed tasks
    let totalTasks: Int      // Total number of tasks
    let fillColor: Color     // The color used for the progress indicator

    /// Calculates the progress percentage as a value between 0 and 1.
    var progress: Double {
        totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }

    var body: some View {
        VStack {
            ZStack {
                // Background circle (inactive part)
                Circle()
                    .stroke(lineWidth: 8)
                    .opacity(0.3)
                    .foregroundColor(fillColor)

                // Foreground progress circle (active part)
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(fillColor)
                    .rotationEffect(Angle(degrees: -90)) // Rotates to start from the top
                    .animation(.easeInOut(duration: 0.5), value: progress)

                // Displays progress percentage in the center
                Text("\(Int(progress * 100))%")
                    .font(.headline)
                    .foregroundColor(fillColor)
            }
            .frame(width: 80, height: 80) // Fixed size for the circular indicator
        }
    }
}
