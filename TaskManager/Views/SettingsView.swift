import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode // Allows dismissing the settings view
    @AppStorage("isDarkMode") var isDarkMode: Bool = false // Stores dark mode preference
    @AppStorage("accentColor") var accentColorHex: String = Color.blue.toHex() // Stores accent color in hex format
    
    @State private var selectedColor: Color = .blue // Local state for selected color
    
    /// Determines accent color based on dark mode state
    var accentColor: Color {
        isDarkMode ? .white : Color.fromHex(accentColorHex)
    }
    
    var body: some View {
        ZStack {
            // Background color adapting to system theme
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
                .accessibilityHidden(true)
            
            VStack(spacing: 20) {
                // Dark Mode Toggle
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .padding()
                    .onChange(of: isDarkMode) { _ in
                        accentColorHex = isDarkMode ? Color.white.toHex() : Color.black.toHex()
                        updateAppAppearance()
                    }
                    .foregroundColor(accentColor)
                    .accessibilityLabel("Enable Dark Mode")
                    .accessibilityHint("Toggles between light and dark mode.")
                
                // Accent Color Picker
                ColorSelectionView(selectedColor: $selectedColor, accentColorHex: $accentColorHex)
                    .accessibilityLabel("Select Accent Color")
                    .accessibilityHint("Choose a custom accent color for the app.")
                
                Spacer()
            }
            .padding()
        }
        // Adjusts color scheme dynamically
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Custom back button with accent color
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    .foregroundColor(accentColor)
                }
                .accessibilityLabel("Go Back")
                .accessibilityHint("Returns to the previous screen.")
            }
        }
        .navigationBarBackButtonHidden(true) // Hides default back button
    }
    
    /// Updates the app's appearance based on the dark mode setting.
    private func updateAppAppearance() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        scene.windows.first?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}
