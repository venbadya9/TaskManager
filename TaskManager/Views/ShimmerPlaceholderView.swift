import SwiftUI

/// A placeholder view that displays shimmering effects while loading tasks.
struct ShimmerPlaceholderView: View {
    
    @StateObject var viewModel: TaskViewModel // ViewModel to access theme settings
    
    var body: some View {
        VStack {
            // Creates three shimmering placeholders to simulate loading task items
            ForEach(0..<3, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.fromHex(viewModel.accentColorHex).opacity(0.3)) // Uses app's accent color with transparency
                    .frame(height: 60) // Placeholder height similar to task cells
                    .shimmer() // Applies shimmering animation effect
            }
        }
        .padding(.top, 20)
    }
}
