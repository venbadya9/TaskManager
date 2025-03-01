import SwiftUI

/// A view modifier that applies a shimmering effect to any SwiftUI view.
struct ShimmerEffectView: ViewModifier {
    @State private var isAnimating = false // Controls animation state
    
    func body(content: Content) -> some View {
        content
            .overlay(
                // Creates a moving gradient overlay for the shimmer effect
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.6),
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.6)
                            ]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .mask(content) // Ensures the shimmer follows the shape of the content
                    .offset(x: isAnimating ? 200 : -200) // Moves shimmer horizontally
            )
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false) // Infinite looping animation
                ) {
                    isAnimating = true
                }
            }
    }
}

/// View extension to apply the shimmer effect easily.
extension View {
    /// Adds a shimmering effect to the view.
    func shimmer() -> some View {
        self.modifier(ShimmerEffectView())
    }
}
