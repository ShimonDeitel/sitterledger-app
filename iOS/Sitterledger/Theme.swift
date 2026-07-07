import SwiftUI

/// playful sky blue with warm sunset orange
enum Theme {
    static let accent = Color(red: 0.2431, green: 0.4863, blue: 0.6941)
    static let accentSecondary = Color(red: 0.9569, green: 0.6353, blue: 0.3490)
    static let background = Color(red: 0.0627, green: 0.0941, blue: 0.1255)
    static let cardBackground = background.opacity(0.6)

    static let titleFont = Font.system(.title2, design: .rounded).weight(.bold)
    static let headlineFont = Font.system(.headline, design: .rounded)
    static let bodyFont = Font.system(.body, design: .rounded)
    static let captionFont = Font.system(.caption, design: .rounded)

    static let cornerRadius: CGFloat = 16
}
