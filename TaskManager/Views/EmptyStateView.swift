import SwiftUI

/// A view displayed when there are no tasks available.
struct EmptyStateView: View {
    @State private var isAnimating = false  // Controls animation state

    var body: some View {
        VStack(spacing: 16) {
            
            // Animated tray icon to indicate an empty state
            Image(systemName: "tray.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .foregroundColor(.gray.opacity(0.5))
                .shadow(radius: 5)
                .scaleEffect(isAnimating ? 1.05 : 1.0) // Subtle breathing effect
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .accessibilityHidden(true)

            // Main empty state message
            Text("No Tasks Available")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .opacity(isAnimating ? 1.0 : 0.5) // Fading effect
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .accessibilityLabel("No tasks available.")

            // Prompt to add a new task with a slight bounce animation
            Text("Tap ➕ to add your first task!")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.7))
                .offset(y: isAnimating ? 2 : -2) // Subtle up-and-down bounce effect
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isAnimating)
                .accessibilityLabel("Tap add button to create a new task.")
        }
        .padding()
        .multilineTextAlignment(.center)
        .onAppear { isAnimating = true } // Start animation when the view appears
        .accessibilityElement(children: .combine)
    }
}
