import SwiftUI

enum DesignSystem {
    static let accent = Color("AccentColor")
    static let background = Color("AppBackground")
    static let surface = Color("CardBackground")
    static let secondarySurface = Color("ElevatedBackground")
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary
    static let warning = Color("Warning")
    static let positive = Color("Positive")
    static let stroke = Color("Stroke")

    enum Spacing {
        static let xSmall: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let xLarge: CGFloat = 24
        static let xxLarge: CGFloat = 32
        static let pagePadding: CGFloat = 20
        static let cardPadding: CGFloat = 16
        static let fieldPadding: CGFloat = 12
        static let sectionSpacing: CGFloat = 24
        static let chipHorizontal: CGFloat = 12
        static let chipVertical: CGFloat = 6
    }

    enum CornerRadius {
        static let small: CGFloat = 10
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }

    enum Typography {
        static let title = Font.title2
        static let titleEmphasis = Font.title
        static let headline = Font.headline
        static let subheadline = Font.subheadline
        static let callout = Font.callout
        static let caption = Font.caption
    }

    enum Layout {
        static let minTapHeight: CGFloat = 44
        static let chipMinHeight: CGFloat = 32
    }
}
