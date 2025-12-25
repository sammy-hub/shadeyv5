import SwiftUI

struct ClientRowView: View {
    let client: Client

    var body: some View {
        SurfaceCardView {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                ClientAvatarView(initials: client.initials)
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(client.name)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    if let lastDate = client.sortedServices.first?.date {
                        Text(lastDate, style: .date)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        Text("No visits yet")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
                Spacer()
                Text("\(client.sortedServices.count) visits")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
