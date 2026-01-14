import SwiftUI

/// A Reminders-style list row with leading icon, primary/secondary text, and optional trailing content
struct ListRowView<Trailing: View>: View {
    let leading: Image
    let title: String
    let subtitle: String?
    let trailing: Trailing
    
    init(
        systemImage: String,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.leading = Image(systemName: systemImage)
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }
    
    init(
        leading: Image,
        title: String,
        subtitle: String? = nil,
        @ViewBuilder trailing: () -> Trailing = { EmptyView() }
    ) {
        self.leading = leading
        self.title = title
        self.subtitle = subtitle
        self.trailing = trailing()
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            leading
                .font(.body)
                .foregroundStyle(.secondary)
                .frame(width: 28, alignment: .center)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer(minLength: 8)
            
            trailing
        }
        .padding(.vertical, 4)
    }
}

