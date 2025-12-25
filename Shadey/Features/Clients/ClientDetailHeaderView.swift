import SwiftUI

struct ClientDetailHeaderView: View {
    let client: Client

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading) {
                HStack {
                    ClientAvatarView(initials: client.initials)
                    VStack(alignment: .leading) {
                        Text(client.name)
                            .font(.title2)
                            .bold()
                            .foregroundStyle(DesignSystem.textPrimary)
                        if let notes = client.notes, !notes.isEmpty {
                            Text(notes)
                                .font(.subheadline)
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                    }
                }
            }
        }
    }
}
