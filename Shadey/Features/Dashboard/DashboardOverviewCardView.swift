import SwiftUI

/// Legacy compatibility - use StatCardView instead
struct DashboardOverviewCardView: View {
    let title: String
    let value: String
    let accentColor: Color

    var body: some View {
        StatCardView(title: title, value: value, accentColor: accentColor)
    }
}
