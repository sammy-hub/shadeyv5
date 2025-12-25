import SwiftUI

struct ClientAvatarView: View {
    let initials: String

    var body: some View {
        ZStack {
            DesignSystem.secondarySurface
                .clipShape(.circle)
            Text(initials)
                .font(.headline)
                .bold()
                .foregroundStyle(DesignSystem.textPrimary)
        }
        .frame(width: 44, height: 44)
    }
}
