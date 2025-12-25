import SwiftUI

struct RecentServicesListView: View {
    let services: [Service]

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                SectionHeaderView(title: "Recent Formulas", subtitle: "Latest client services")
                if services.isEmpty {
                    Text("No services logged yet.")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        ForEach(services, id: \.id) { service in
                            RecentServiceRowView(service: service)
                        }
                    }
                }
            }
        }
    }
}
