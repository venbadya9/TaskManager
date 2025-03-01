import SwiftUI

// MARK: - Color Extension for Hex Conversion
extension Color {
    
    /// Converts a `Color` to its hexadecimal string representation.
    /// - Returns: A hex string in the format `#RRGGBB`. Defaults to `#000000` if conversion fails.
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else {
            return "#000000" // Fallback to black if unable to extract components
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    /// Creates a `Color` from a hexadecimal string.
    /// - Parameter hex: A hex string in the format `#RRGGBB` or `RRGGBB`.
    /// - Returns: A `Color` instance corresponding to the hex value.
    static func fromHex(_ hex: String) -> Color {
        // Sanitize the input string by trimming spaces and removing the `#`
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
                              .replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
}

// MARK: - DateFormatter Extension for Short Date Format
extension DateFormatter {
    
    /// A pre-configured `DateFormatter` for displaying dates in short style.
    static let shortStyle: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short // Uses system locale short date format
        return formatter
    }()
}
