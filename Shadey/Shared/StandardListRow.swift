import SwiftUI

/// Standard Reminders-style list row used across the app.
/// Prefer this over any custom card views to maintain consistency and density.
typealias StandardListRow<Trailing: View> = ListRowView<Trailing>

extension StandardListRow where Trailing == EmptyView {
    init(systemImage: String, title: String, subtitle: String? = nil) {
        self = ListRowView(systemImage: systemImage, title: title, subtitle: subtitle) { EmptyView() }
    }

    init(leading: Image, title: String, subtitle: String? = nil) {
        self = ListRowView(leading: leading, title: title, subtitle: subtitle) { EmptyView() }
    }
}

