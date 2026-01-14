import SwiftUI

struct RecentServicesListView: View {
    let services: [Service]

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                SectionHeaderView(title: "Recent Formulas", subtitle: "Latest client services")
                if services.isEmpty {
                    VStack(spacing: DesignSystem.Spacing.small) {
                        Image(systemName: "clock")
                            .font(DesignSystem.Typography.title)
                            .foregroundStyle(DesignSystem.textSecondary)
                        Text("No services logged yet.")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, DesignSystem.Spacing.large)
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
