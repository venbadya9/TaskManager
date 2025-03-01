import SwiftUI

/// A view that allows users to select an accent color.
struct ColorSelectionView: View {
    
    /// The currently selected color, bound to the parent view.
    @Binding var selectedColor: Color
    
    /// The hex representation of the selected accent color, stored in AppStorage.
    @Binding var accentColorHex: String
    
    var body: some View {
        VStack(spacing: 15) {
            
            // Title Text
            Text("Choose Accent Color")
                .font(.headline)
                .padding(.top, 10)
                .foregroundColor(Color.fromHex(accentColorHex)) // Dynamic text color
            
            // System Color Picker
            ColorPicker("Pick a color", selection: $selectedColor)
                .onChange(of: selectedColor) {
                    accentColorHex = selectedColor.toHex() // Convert color to hex for storage
                }
                .padding()
            
        }
        .padding()
        .background(Color.fromHex(accentColorHex).opacity(0.2)) // Subtle background tint
        .clipShape(RoundedRectangle(cornerRadius: 15)) // Rounded card-like appearance
        .shadow(radius: 5) // Soft shadow effect
        .padding(.horizontal)
    }
}
